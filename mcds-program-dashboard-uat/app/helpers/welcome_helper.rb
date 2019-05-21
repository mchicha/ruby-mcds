module WelcomeHelper
  def formatted_date_range(date_range)
    "#{format_date(date_range.start_date)} - #{format_date(date_range.end_date)}"
  end

  def format_date(date)
    return '' unless date
    date.strftime('%-m/%-d/%y')
  end

  def kit_delivery_display(name)
    # Client requested Kit Delivery to be taken off homepage but this method left for when they change their minds
    name = 'DC' if name == 'Distribution Center'
    " Through: #{name}"
  end

end
