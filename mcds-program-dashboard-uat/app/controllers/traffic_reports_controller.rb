class TrafficReportsController < ApplicationController
  before_action :require_user
  load_and_authorize_resource

  def index
    params[:incident_type] = nil if params[:incident_type] == 'All'
    params[:archived] = nil if params[:archived] == 'All'
    params[:seen] = nil if params[:seen] == 'All'

    @incident_type = params[:incident_type]
    @archived = params[:archived]
    @seen = params[:seen]


    if @archived
      @archived = [nil, false] if @archived == 'false'
      @archived = true if @archived == 'true'
      @traffic_reports = @traffic_reports.where(archived: @archived)
    end

    if @seen
      @seen = [nil, false] if @seen == 'false'
      @seen = true if @seen == 'true'
      @traffic_reports = @traffic_reports.where(seen: @seen)
    end

    @traffic_reports = @traffic_reports.where(incident_type: @incident_type) if @incident_type

    @traffic_reports = @traffic_reports.order(id: :desc).page(params[:page])
  end

  def show
    @traffic_report.update_attributes(seen: true) unless @traffic_report.seen
  end

  def archive
    @traffic_report.update_attributes(archived: params[:archived])
    redirect_to request.referer
  end

end
