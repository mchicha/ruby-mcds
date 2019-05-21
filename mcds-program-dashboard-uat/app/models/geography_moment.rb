class GeographyMoment < ActiveRecord::Base
  belongs_to :geography
  belongs_to :moment
end
