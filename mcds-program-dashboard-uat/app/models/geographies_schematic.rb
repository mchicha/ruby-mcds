class GeographiesSchematic < ActiveRecord::Base
  belongs_to :schematic
  belongs_to :geography
end
