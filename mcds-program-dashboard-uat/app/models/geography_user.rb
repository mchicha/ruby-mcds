class GeographyUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :geography
end
