module GeographiesHelper

  def select_geography(geography, obj)
    if geography.is_a_co_op?
      checked = obj.blank? ? false : obj.geographies.include?(geography)
      check_box_tag("geography_ids[]", geography.id, checked, class: "co-op-checkbox", onclick: "addNewGeographies(this)", "data-geography-name" => geography.name) + geography.name
    else
      link_to(geography.name, geography_children_path(geography, obj_id: obj, class_name: obj.class), remote: true, class: "tree-toggler")
    end
  end

end
