class TrafficReport < ActiveRecord::Base
  enum incident_type:[
    'Template Name Not Found',
    'Program ID Not Found',
    'Asset Update Worker Fail',
    'Program Update Worker Fail'
  ]

  def self.no_metadata_found(template_name, asset)
    self.generate(
      incident_type: "Template Name Not Found",
      body: "The Template Name in question was: #{template_name}. \n The Asset information in question was: #{asset}"
    )
  end

  def self.no_program_found(program_id, asset)
    self.generate(
      incident_type: "Program ID Not Found",
      body: "The Program ID in question was: #{program_id}. \n The Asset information in question was: #{asset}"
    )
  end

  def self.update_asset_fail(response, processed_asset, auth_key)
    self.generate(
        incident_type: "Asset Update Worker Fail",
        body:"The Asset ID in question was: #{processed_asset['id']}. \n The new Metadata: #{processed_asset['metadata']}. \n The full request sent was: #{{body: {'asset' => processed_asset}, headers: {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_key)}}}. The response was: #{response}"
      )
  end

  def self.program_update_fail(response, request_body, auth_key)
    self.generate(
        incident_type: "Program Update Worker Fail",
        body:"The Asset ID in question was: #{request_body['asset_type_id']}. \n The Program ID in question was:#{request_body['update_queries'].first['metadata_value']}. \n The full request sent was: #{{body: {'asset' => request_body}, headers: {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_key)}}}. The response was: #{response}"
      )
  end

  def self.generate(opts = {})
    traffic_report = self.new
    traffic_report.incident_type = opts[:incident_type]
    traffic_report.body = opts[:body]
    traffic_report.save
  end
end
