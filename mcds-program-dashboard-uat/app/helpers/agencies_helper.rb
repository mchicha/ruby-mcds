module AgenciesHelper

  def belongs_to_agency_and_geography(user, geography)
    user.geographies.include?(geography)
  end

end
