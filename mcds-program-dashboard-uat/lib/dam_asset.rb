class DamAsset
  include HTTParty
  base_uri DAM_CONFIG["host"]
  headers "Authorization" =>  "Token #{DAM_CONFIG['client_token']}"

  def initialize(search=nil, archived=false)
    @options = { query: {search: search, archived: archived} }
  end

  def retrieve_assets
    self.class.get("/api/assets", @options)
  end

  def retrieve_asset_types
    asset_types = self.class.get("/api/asset_types", @options)
    asset_types = asset_types.blank? ? [] : asset_types["asset_types"]
  end

  def search_for_assets
    # add asset_type_id to options hash
    # TODO: Still a WIP.. not working entirely just yet
    @options[:query][:asset_type_id] = @asset_types.first["id"]
    searched_assets = self.class.post("/api/assets/search", @options)
  end

end
