class CoopSerializer < ActiveModel::Serializer
  attributes :id, :name, :ancestry, :geography_type_id
  has_many :ancestors
end
