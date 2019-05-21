class GeographyMessage < ActiveRecord::Base
  belongs_to :geography
  belongs_to :message
end
