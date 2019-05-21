class SchematicSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :status,
              :release_date,
              :end_date,
              :updated_at,
              :parent_id,
              :last_modified_by,
              :sch_type,
              :test?,
              :archived?,
              :agencies,
              :programs

              has_many    :geographies, serializer: GeographiesSerializer, embed: :ids, embed_in_root: true
end
