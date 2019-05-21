module DamQueryGenerator

  def send_request
    auth_key = DAM_CONFIG['client_token']

    HTTParty.get("http://#{DAM_CONFIG['host']}/api/asset_types/", {
      body: {verbose: true}, headers: {'Authorization' => ActionController::HttpAuthentication::Token.encode_credentials(auth_key)}
    })
  end

  def dam_request
    @request ||= send_request
  end

  def asset_types
    dam_request['asset_types'] || []
  end

  def param_ids_from_name(name, asset_type_id)
    possible_params = dam_request['parameters'].select{|param| param['name'] == name}
    selected_asset = asset_types.select{|at| at['id'] == asset_type_id}.first
    matched_param = possible_params.select{|param| selected_asset['parameter_ids'].include?(param['id'])}.first
    matched_param.try(:[], 'id')
  end

  def update_param_hash(new_metadata_values)
    {asset: {metadata: new_metadata_values}, skip_custom_callbacks: 'true'}
  end

  def row_generator(metadata_id, query_value, new_metadata, asset_type_id)
    new_mdata = process_metadata(new_metadata, asset_type_id)
    readied_hash = update_param_hash(new_mdata)

    {
      metadata_key: metadata_id,
      oper: "string",
      metadata_value: query_value,
      update_params: readied_hash
    }
  end

  def process_metadata(metadata_named, asset_type_id)
    metadata_named.inject({}) do |memo, (name, value)|
      id = param_ids_from_name(name, asset_type_id)
      memo[id] = value
      memo
    end
  end

  def program_update_request(new_metadata, prog_id)
    asset_types.inject([]) do |memo, asset_type|
      id = asset_type['id']
      query_id = param_ids_from_name('Program ID', id)

      request_params = {asset_type_id: id}

      request_params[:update_queries] = [row_generator(query_id, prog_id, new_metadata, id)]
      memo << request_params
    end
  end

  def lookup_table_updates(change_hash)
    asset_types.inject([]) do |memo, asset_type|
      id = asset_type['id']
      request_params = {asset_type_id: id}

      request_params[:update_queries] = change_hash.inject([]) do |collection, (key, column)|
        query_id = param_ids_from_name('Template Name', id)
        collection << row_generator(query_id, key, column, id)
      end

      memo << request_params
    end
  end

end
