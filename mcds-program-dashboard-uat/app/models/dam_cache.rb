class DamCache
  attr_accessor :rows

  def self.assets
    self.load_or_request(key_name: 'assets')
  end

  def self.parsed_assets_value
    JSON.parse(self.assets).try(:[], 'assets') || []
  end

  def self.parsed_asset_types
    JSON.parse(self.asset_types) || []
  end

  def self.asset_types
    self.load_or_request(key_name: 'types')
  end

  def self.clear(key_name)
    Redis.current.del(key_name)
  end

  def self.load_or_request(opts = {})
   key_string = opts[:key_name]
    cached = Redis.current.get(key_string)

    if !cached
      cached = live_request(opts)
      Redis.current.setex(key_string, opts[:ttl] || 3600, cached.to_json)
    end

    cached
  end

  def self.live_request(opts = {})
    HTTParty.get("http://#{DAM_CONFIG['host']}/api/#{model_param(opts[:key_name])}/", {
      body: {
        verbose: true
      },
      headers: {
        'Authorization' => authorization_credentials
      }
    })
  end

  def self.model_param(key_name)
    key_name == 'types' ? 'asset_types' : key_name
  end

  def self.authorization_credentials
    ActionController::HttpAuthentication::Token.encode_credentials(
      DAM_CONFIG['client_token']
    )
  end

  def self.dam_asset_request
    DamAsset.new.retrieve_assets
  end

  def self.find_asset(id)
    self.parsed_assets_value.detect{|asset| asset['id'].to_s == id.to_s} || {}
  end

  def self.find_asset_type(id)
    full_json = self.parsed_asset_types.dup

    full_json['asset_type'] = full_json['asset_types'].detect{|v| v['id'].to_s == id.to_s}

    param_ids = full_json['asset_type']['parameter_ids'].map(&:to_i)
    matched_params = full_json['parameters'].select{|v| param_ids.include?(v['id'].to_i)}

    full_json.except!('asset_types')
    full_json['parameters'] = matched_params

    full_json
  end

  def self.send_asset_params(params)
    response = self.faraday_request(params)
    self.clear("assets")
    response
  end

  def self.base_faraday_connection
    Faraday.new "http://#{DAM_CONFIG['host']}/api/assets" do |faraday|
      faraday.request :multipart
      faraday.headers['Content-Type'] = 'multipart/form-data'
      faraday.adapter Faraday.default_adapter

      faraday.headers['Authorization'] = authorization_credentials
    end
  end

  def self.convert_upload(upload_document)
    Faraday::UploadIO.new upload_document.path, upload_document.content_type
  end

  def self.faraday_request(params)
    # Can't use HTTParty due to the file upload, used this gist linked from SO article
    # https://gist.github.com/mjquinlan2000/10929611

    connection = self.base_faraday_connection

    params[:asset][:document] = self.convert_upload(params[:asset][:document])

    connection.post "http://#{DAM_CONFIG['host']}/api/assets", {asset: params[:asset], asset_type_id: params[:asset_type_id]}
  end

end
