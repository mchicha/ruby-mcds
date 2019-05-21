class LookupTablesController < ApplicationController
  include DamQueryGenerator

  before_action :require_user
  load_and_authorize_resource

  def index
    @lookup_tables = LookupTable.limit(50).descending
  end

  def new
    @lookup_table = LookupTable.new
  end

  def create
    @lookup_table = LookupTable.new(lookup_table_params)
    if @lookup_table.save
      redirect_to action: 'show', id: @lookup_table.id
    else
      flash[:error] = "Could not save"
      render "new"
    end
  end

  def show
    @lookup_table = LookupTable.find(params[:id])
  end

  def new_import

  end

  def import
    LookupTable.import_spreadsheet(spreadsheet: params['spreadsheet'], table_name: params['table_name'], key_field_name: params['key_field_name'])

    redirect_to action: :index
  end

  def edit
    @lookup_table = LookupTable.find(params[:id])
  end

  def user_changes_sync
    changed_hash = LookupTable.detect_manual_updates('Template Name', ['friendly', 'position'])
    changed_hash = lookup_table_updates(changed_hash)

    if changed_hash.present?
      sync_to_dam(changed_hash)

      flash[:success] = 'Update Workers Started only For Keys Detected as Manually Changed'
    else
      flash[:notice] = 'No manual changes detected, no data sent to the DAM'
    end

    redirect_to action: :index
  end

  def smart_sync
    changed_hash = LookupTable.detect_key_changes('Template Name', ['friendly', 'position'])
    changed_hash = lookup_table_updates(changed_hash)

    if changed_hash.present?
      sync_to_dam(changed_hash)

      flash[:success] = 'Update Workers Started only For Keys Detected as Changed'
    else
      flash[:notice] = 'No differences between newest and second newest tables found, no worker started. Run Total Sync to force data to be sent'
    end

    redirect_to action: :index
  end

  def total_sync
    table_hash = LookupTable.merge_most_recent_tables('Template Name', ['friendly', 'position'])
    table_hash = lookup_table_updates(table_hash)

    if table_hash.present?
      sync_to_dam(table_hash)

      flash[:success] = 'Update Workers Started only For All Keys'
    else
      flash[:notice] = 'Could not find the most recent tables'
    end

    redirect_to action: :index
  end

  def update
    @lookup_table = LookupTable.find(params[:id])
    if @lookup_table.update(lookup_table_params)
      render "show"
    else
      flash[:error] = "Could not save"
      render "edit"
    end
  end

  def archive
    @lookup_table.update(lookup_table_params)
    redirect_to :back
  end


  private

  def lookup_table_params
    params.require(:lookup_table).permit(:key_field_name, :table_name, :transformation_id, :archived, :id)
  end

  def sync_to_dam(changed_hash)
    changed_hash.each do |asset_type_body|
      DamLookupTableUpdateWorker.perform_async(asset_type_body, current_user.email)
    end
  end

end
