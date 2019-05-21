class Api::V1::GeographiesController < ApplicationController
  respond_to :json, :html

  def index
    @geographies = Geography.arrange_serializable do | parent, children |
      GeographiesSerializer.new(parent, children: children)
    end

    respond_with @geographies
  end

  def list
    top_level_prominence = {"EAST ZONE" => 0, "WEST ZONE" => 1, "EOTF ZONE" => 9, "National" => 10}
    @roots = Geography.roots

    @roots = @roots.sort_by{|top, childs| top_level_prominence[top.name] || 8}


    respond_with @roots, layout: false
  end

  def drop_down
    @geographies = Geography.geographies_for_user_dropdown(current_user)
    respond_with @geographies, layout: false
  end
end
