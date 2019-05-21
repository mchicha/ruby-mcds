class GeographyProgram < ActiveRecord::Base
  self.table_name = 'geographies_programs' 
  belongs_to :geography
  belongs_to :program
end
