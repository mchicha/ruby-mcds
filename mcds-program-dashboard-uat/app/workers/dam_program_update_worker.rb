class DamProgramUpdateWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform(body)
    auth_key = DAM_CONFIG['client_token'] #Once figure out what key is, define here, in local paste one in for now

    response = HTTParty.post("http://#{DAM_CONFIG['host']}/api/assets/batch",
      {body: body, headers: {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_key)}}
    )

    unless response['status'] == '200'
      # MessageMailer.dam_program_update_fail(response, body, auth_key).deliver
      TrafficReport.program_update_fail(response, body, auth_key)
    end
  end
end
