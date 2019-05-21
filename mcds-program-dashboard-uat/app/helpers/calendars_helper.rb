module CalendarsHelper

  def list_geography_names(event)
    co_op_names = event.geographies.map(&:name).join(", ")
    coop_string = ""

    unless co_op_names == 'National'
      coop_string += "Co-op Name(s):  "
    end

    coop_string += "#{co_op_names}"

    if co_op_names == 'National'
    	coop_string += " Event"
    end

    coop_string
  end

  def dates_to_week_array(start_date, end_date)
    calendar = [[]]

    starting_day = start_date.wday
    curr_week = 0

    (start_date..end_date).to_a.each do |date|
      if date == start_date
        starting_day.times do
          calendar[0] << nil
        end
      end

      calendar[curr_week] << date

      if date.wday == 6
        curr_week +=1
        calendar << []
      end
    end

    calendar
  end
end
