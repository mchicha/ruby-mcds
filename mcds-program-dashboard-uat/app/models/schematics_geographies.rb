class SchematicsGeographies < ActiveRecord::Base

  belongs_to :geographies
  belongs_to :schematics
end
