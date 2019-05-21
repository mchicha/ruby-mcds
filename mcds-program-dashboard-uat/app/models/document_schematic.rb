class DocumentSchematic < ActiveRecord::Base
  belongs_to :schematic
  belongs_to :document
end
