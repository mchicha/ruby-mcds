class Api::V1::DamAssetsController < ApplicationController
  include HTTParty
  respond_to :json

  before_filter :api_authenticate

  def notify
    render json: {status: '202'}
    asset = params['asset']


    # prevent infinite loop when sent back to DAM (if callback is :on_update or :on_save):
    asset['skip_custom_callbacks'] = true

    # prevent an unecessary call to the FTP after the asset is updated
    asset['skip_asset_rec_callback'] = true

    # set what the DAM thinks default status is
    status = 'pending'

    # turn arraified metadata into a hash, and create a key of what ids are
    meta_key = {}
    asset['metadata'] = asset['metadata'].inject({}) do |memo, record|
      meta_key[record['name']] = record['id']
      memo[record['id']] = record['value']
      memo
    end


    # set template name information
    template_name = asset['metadata'][meta_key['Template Name']]

    metadata_to_merge = LookupTable.get_template_name_by_key(template_name)

    if metadata_to_merge.blank?
      # MessageMailer.no_metadata_found(template_name, asset).deliver if template_name.present?
      TrafficReport.no_metadata_found(template_name, asset) if template_name.present?
    else
      status = 'processed'

      metadata_to_merge.each do |metadata_name, value|
        asset['metadata'][meta_key[metadata_name]] = value
      end

    end

    # PG is case sensitive but MYSQL is not. Rather than have the DAM downcase template name (client specific),
    # as all assets will come over here when created and updated by the notify custom callback, they are
    # downcased here so that the batch update on 'Template Name' will work in the future
    asset['metadata'][meta_key['Template Name']] = template_name.downcase


    # set program info
    program_id = asset['metadata'][meta_key['Program ID']]

    if program_id.present?
      program = Program.find_by(id: program_id)

      if program.present?
        status = 'processed'

        asset['metadata'][meta_key['Program Name']] = program.name
        asset['metadata'][meta_key['National Job Number']] = program.number
        asset['metadata'][meta_key['Market Category']] = program.color_blocks.first.try(:name)

        pop_install = program.date_ranges.find_by(date_type: (DateType.where(name: 'pop_install')))

        if pop_install
          asset['metadata'][meta_key['Up Date']] = pop_install.start_date.strftime('%m/%d/%Y')
        end

        pop_take_down = program.date_ranges.find_by(date_type: (DateType.where(name: 'pop_take_down')))

        if pop_take_down
          asset['metadata'][meta_key['Down Date']] = pop_take_down.start_date.strftime('%m/%d/%Y')
        end
      else
        # MessageMailer.no_program_found(program_id, asset).deliver
        TrafficReport.no_program_found(program_id, asset)
      end
    end

    asset['metadata'][meta_key['Status']] = status

    unless asset['metadata'][meta_key['Depth']].present?
      asset['metadata'][meta_key['Depth']] = 'N/A'
    end

    #in case any metadata fields were not saved as params
    asset['metadata'].reject!{|key, val| key.nil?}

    #send asset back to dam
    send_asset_to_dam(asset)

    ### Update Existing ELements Where DAM Paths Are Out Of Date ###
    Element.update_id_and_hrefs(asset['id'], asset['medium_url'])
  end

  private

  def api_authenticate
    authenticate_token || render_unauthorized
  end
# CHECK UNAUTHORIZED
  def authenticate_token
    authenticate_with_http_token do |token, options|
      token == DAM_CONFIG['inbound_token']
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { errors: ['Credentials not authorized.'] }, status: :unauthorized
  end

  def send_asset_to_dam(processed_asset)
    DamUpdateAssetWorker.perform_async(processed_asset)
  end
end
