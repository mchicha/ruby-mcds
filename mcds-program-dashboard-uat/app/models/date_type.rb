class DateType < ActiveRecord::Base

  has_many :date_ranges

  scope :dates_for_calendar, -> { where(show_on_calendar: true) }

  def get_class_name
    class_name.blank? ? "lighter" : class_name
  end

  def self.calendar_date_type_ids
    DateType.dates_for_calendar.pluck(:id)
  end

  def view_name
    self.display_name || self.name.try(:titleize)
  end
end
