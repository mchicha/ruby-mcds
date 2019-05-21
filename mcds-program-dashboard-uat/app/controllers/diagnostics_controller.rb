class DiagnosticsController < ApplicationController
  before_action :require_user
  before_action :check_access

  def index
    table_combined_hash = LookupTable.merge_most_recent_tables('Template Name', ['position', 'friendly'])

    incompletes = table_combined_hash.select{|k,v| v.count < 5}

    @position_incompletes = incomplete_filter(incompletes, 'Position Name')
    @friendly_incompletes = incomplete_filter(incompletes, 'Element Name')

    @grandparent_schematics = Schematic.where(parent_id: nil).preload(:children).select{|parent| parent.children.detect{|child| child.children.present?}}
    @published_national_schematic_count = Schematic.where(parent_id: nil).for_requested_geographies(Geography.national.id).published.count
  end

  def incomplete_filter(incompletes, key_name)
    # sorts incomplete keys based on a key that they DO have
    incompletes.select{|k,v| v.has_key?(key_name)}.map{|k,v| k}.sort
  end

  def check_access
    authorize! :read, :diagnostic
  end
end
