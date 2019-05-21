class Event

  EVENT_CATEGORIES = %w(Message National COOP)

  def self.single_day_event(event_category, user, start_date, display_action, search_field=nil, coops=nil)
    case event_category
      when 'Message'
        events = message_events(event_category, user, start_date, search_field, coops)
      when 'National', 'COOP'
        events = program_events(event_category, user, start_date, search_field, coops)
        events << message_events(event_category, user, start_date, search_field, coops) if display_action == 'show'
    end
    events
  end

  def self.program_events(event_category, user, start_date, search_field=nil, coops=nil)
    Program.for_calendar(
      event_category: event_category,
      user: user,
      start_date: start_date,
      coops: coops,
      search_field: search_field
    )
  end

  def self.message_events(event_category, user, start_date, search_field=nil, coops=nil)
    Message.for_calendar(
      user: user,
      start_date: start_date,
      coops: coops,
      search_field: search_field,
      event_category: event_category
    )
  end
end
