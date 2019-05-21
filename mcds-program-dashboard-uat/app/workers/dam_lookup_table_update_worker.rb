class DamLookupTableUpdateWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform(body, initiator)
    auth_key = DAM_CONFIG['client_token']

    response = HTTParty.post("http://#{DAM_CONFIG['host']}/api/assets/batch",
      {body: body, headers: {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_key)}}
    )

    if response['status'] == '200'
      MessageMailer.dam_lookup_table_success(initiator).deliver_now
    else
      MessageMailer.dam_lookup_table_fail(response, body, initiator, auth_key).deliver_now
    end
  end

end
