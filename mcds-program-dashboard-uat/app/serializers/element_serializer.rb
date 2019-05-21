class ElementSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :editable,
              :zindex,
              :values,
              :layout_id,
              :group,
              :primary_dam_asset_id,
              :primary_dam_asset_path,
              :secondary_dam_asset_id,
              :secondary_dam_asset_path,
              :primary_program_id,
              :secondary_program_id,
              :layer_name,
              :type_of,
              :grayscale
end
