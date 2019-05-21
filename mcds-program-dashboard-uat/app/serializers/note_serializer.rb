class NoteSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :body,
              :width,
              :height,
              :x,
              :y,
              :updated_at
end
