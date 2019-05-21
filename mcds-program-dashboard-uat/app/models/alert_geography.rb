class AlertGeography < ActiveRecord::Base
  belongs_to :geography
  belongs_to :alert
end
