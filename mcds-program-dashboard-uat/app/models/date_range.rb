class DateRange < ActiveRecord::Base
  belongs_to :date_type
  has_and_belongs_to_many :programs

  scope :kit_delivery_dates, -> {joins(:date_type).where(date_types: {name: "kit_delivery_between"})}

  def self.pop_install_dates
    joins(:date_types).where(name: "pop_install")
  end

end
