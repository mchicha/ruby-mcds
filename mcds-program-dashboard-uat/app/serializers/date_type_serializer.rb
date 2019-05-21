class DateTypeSerializer < ActiveModel::Serializer
  attributes  :id,
              :name,
              :display_name
end
