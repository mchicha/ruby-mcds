module SelectableGeographies
  extend ActiveSupport::Concern

  def find_selectable_geographies
    # @root_geographies = if current_user.admin?
      @root_geographies = Geography.roots
    # else
      # current_user.geographies
    # end
  end


  def arranged_selected_geograpgies
    @arranged_geographies = []

    # .arrage gives a multi-dimensional array when called with .each
    # We only want categories with children in them, thus no "New York" if user
    # can't see any New York coops

    Geography.menu_geographies(current_user).preload(:geography_type).arrange.each do |root|
      if root.first.name == Geography::NATIONAL_NAME
        # National has no children, so if it gets past the scope query, it should be taken
        @arranged_geographies << root
      else
        root_children = []

        ActiveSupport::OrderedHash[root.last.sort_by{|k,h| k.name}].each do |child|
          grandchildren = []

          ActiveSupport::OrderedHash[child.last.sort_by{|k,h| k.name.match(/(\d+\s-\s)(\D+)/).try(:[], 2)}].each do |grandchild|
            grandchildren << grandchild
          end

          if grandchildren.length > 0
            root_children << [child.first, grandchildren]
          end
        end

        if root_children.length > 0
          @arranged_geographies << [root.first, root_children]
        end
      end
    end

    top_level_prominence = {"EAST ZONE" => 0, "WEST ZONE" => 1, "EOTF ZONE" => 9, "National" => 10}

    @arranged_geographies = @arranged_geographies.sort_by{|top, childs| top_level_prominence[top.name] || 8}
  end
end
