class Agency < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_and_belongs_to_many :geographies

  validates :name, presence: true, uniqueness: true

end
