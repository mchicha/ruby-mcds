class EventsController < ApplicationController

  before_action :event_params
  respond_to :json, :html, :js

  def index
    @events =
      Calendar.find_by(user_id: current_user).
        calendar_grid_programs(@user, params[:start], params[:end], @coops).
        group('date_ranges.start_date, geographies.geography_type_id').
        select('date_ranges.start_date as start_date, geographies.geography_type_id, count(distinct programs.id) as program_count') +
      (Calendar.find_by(user_id: current_user).
        calendar_grid_messages(@user, params[:start], params[:end], @coops).
        group('published_date').
        select('date_format(publish_date, "%Y-%m-%d") as published_date, null, count(distinct messages.id) as program_count'))

    render json: @events, each_serializer: EventSerializer, root: false
  end

  def show
    events = []

    @event_categories.each do |event_category|
      events << Event.single_day_event(event_category, @user, @start_date, 'show', params[:search_field], @coops)
    end

    @events = events.flatten.uniq.sort_by(&:created_at)
    total_events_for_single_day(@events)
  end

  def show_modal
    @events = Event.single_day_event(@event_category, @user, @start_date, 'show_modal', params[:search_field], @coops).flatten.uniq.sort_by(&:created_at)
    render :show_modal, layout: false
  end

  private

    def event_params
      @user = params[:user_selected] == 'all' ? nil : current_user.id
      @coops = params[:coops].blank? ? nil : params[:coops].split(',').map(&:to_i)
      @start_date = params[:start_date].nil? ? DateTime.now.beginning_of_day.utc : params[:start_date].to_time.utc.to_datetime
      @event_categories = params[:event_categories].nil? || params[:event_categories] == 'All' ? Event::EVENT_CATEGORIES : params[:event_categories].split(",")
      @event_category = params[:event_category]
     end

    def total_events_for_single_day(events)
      @national_events_count = events.find_all{|event| event.geographies.any? {|geography| geography.geography_type_id.nil?}}.length
      @coop_events_count = events.find_all{|event| event.geographies.any? {|geography| geography.geography_type_id == 4}}.length
      @all_events_count = @national_events_count + @coop_events_count
    end
end
