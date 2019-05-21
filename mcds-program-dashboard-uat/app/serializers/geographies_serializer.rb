class GeographiesSerializer < ActiveModel::Serializer
  attributes :id, :name, :ancestry, :geography_type_id
  has_many :children
end
