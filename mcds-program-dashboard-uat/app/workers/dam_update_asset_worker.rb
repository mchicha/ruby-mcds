class DamUpdateAssetWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform(processed_asset)
    auth_key = DAM_CONFIG['client_token']

    response = HTTParty.put("http://#{DAM_CONFIG['host']}/api/assets/#{processed_asset['id']}",
      {body: {'asset' => processed_asset}, headers: {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_key)}}
    )

    if !response.has_key?('asset')
      # MessageMailer.dam_update_asset_email(response, processed_asset, auth_key).deliver
      TrafficReport.update_asset_fail(response, processed_asset, auth_key)
    end
  end
end
