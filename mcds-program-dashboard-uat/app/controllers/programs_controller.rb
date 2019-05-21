class ProgramsController < ApplicationController
  include SelectableGeographies
  include DamQueryGenerator
  include ProgramsHelper

  before_action :require_user

  before_filter :selected_geographies, only: [:index, :filter_programs]

  before_filter :find_program, except: [:index, :new, :create, :filter_programs]
  before_filter :find_programs_for_requested_geographies, only: [:index, :filter_programs]
  before_filter :find_selectable_geographies, only: [:create, :update]
  before_filter :arranged_selected_geograpgies, only: [:edit, :new, :create, :update]
  before_filter :set_date_types, only: [:edit, :new, :create, :update, :show]
  # before_filter :program_assets, only: [:new, :create, :update, :show]

  load_and_authorize_resource

  # breadcrumb
  add_breadcrumb "Programs", :programs_path

  def index
    capture_user_hitting_route
    @pop_install_date_type = DateType.find_by(name: "pop_install")
    @programs = @programs.order(id: :desc)
  end

  def new
    @program = Program.new
    build_program_dates
    @color_blocks = ColorBlock.all
    @new_program = @program.new_record?
    add_breadcrumb "New Program", new_program_path
  end

  def show
    capture_user_hitting_route
    add_breadcrumb "Program Details", program_path(@program)
  end

  def create
    @program = Program.new(program_params)
    @program.user_id = current_user.id
    assign_geographies_to_programs(params[:geography_ids] || [])

    if @program.save
      save_program_dates(params[:program][:date_ranges_attributes] || [])
      assign_color_blocks_to_programs(params[:color_block_ids] || [])
      program_update_request(@program.info_for_dam, @program.id).each do |asset_type_request|
        DamProgramUpdateWorker.perform_async(asset_type_request)
      end
      flash[:success] = "Program has been successfully created"
      redirect_to programs_path
    else
      render_error_message
      set_dates_for_form
      @color_blocks = ColorBlock.all
      add_breadcrumb "New Program", new_program_path
      render :new
    end
  end

  def edit
    capture_user_hitting_route
    @color_blocks = ColorBlock.all
    build_program_dates
    add_breadcrumb "Edit Program", edit_program_path(@program)
  end

  def update
    assign_geographies_to_programs(params[:geography_ids] || [])

    if @program.update_attributes(program_params)
      # save dates
      save_program_dates(params[:program][:date_ranges_attributes] || [])
      assign_color_blocks_to_programs(params[:color_block_ids] || [])

      program_update_request(@program.info_for_dam, @program.id).each do |asset_type_request|
        DamProgramUpdateWorker.perform_async(asset_type_request)
      end

      flash[:success] = "Program successfully saved."
      redirect_to program_path(@program)
    else
      render_error_message
      set_dates_for_form
      @color_blocks = ColorBlock.all
      add_breadcrumb "Edit Program", edit_program_path(@program)
      render :edit
    end
  end

  def destroy
    capture_user_hitting_route
    if @program.destroy
      redirect_to programs_path
    end
  end

  def add_geographies
    assign_geographies_to_programs(params[:geography_ids])
    flash[:success] = "#{params[:geography_ids].count } Co-ops have been added to this program."
    respond_to do |format|
      format.html { redirect_to edit_program_path(@program)}
    end
  end

  def add_color_blocks
    @color_block = ColorBlock.find(params[:color_block_id])
    @program.color_blocks << @color_block if @color_block
    respond_to do |format|
      format.js
    end
  end

  def remove_color_block
    @color_block = ColorBlock.find(params[:color_block_id])
    @program.color_blocks.delete(@color_block)
    respond_to do |format|
      format.js
    end
  end

  def update_status
    @program.update_attributes(status_id: params[:status_id])
    redirect_to programs_path
  end

  def filter_programs
    @programs = filter_based_on_pop_install_dates if pop_install_date_params[:start].present?
    @programs = filter_based_on_updated_at if updated_at_params[:start].present?
    @programs = filter_based_on_keyword if keyword_params[:keyword].present?
    @programs = filter_based_on_status if status_params[:status].present?
    @pop_install_date_type = DateType.find_by(name: "pop_install")
  end

private

  def find_programs_for_requested_geographies
    @programs = Program.all.for_requested_geographies(@selected_geography_ids)
  end

  def filter_based_on_selected_users
    @programs.for_specific_users(user_params)
  end

  def filter_based_on_updated_at
    @programs.updated_at_range(updated_at_params[:start], updated_at_params[:end])
  end

  def filter_based_on_pop_install_dates
    @programs.date_ranges_for_type(pop_install_date_params[:start], pop_install_date_params[:end], "pop_install")
  end

  def filter_based_on_selected_geographies
    @programs.for_specific_geographies(geography_params)
  end

  def geography_params
    params.require(:program).require(:geography_id).reject{|i| i if i.blank? }
  end

  def user_params
    params.require(:program).require(:user_id).reject{|i| i if i.blank? }
  end

  def updated_at_params
    params.require(:program).require(:updated_at)
  end

  def pop_install_date_params
    params.require(:program).require(:pop_install)
  end

  def filter_programs_params
    params[:program]
  end

  def program_params
    params.require(:program).permit(
      :name, :number, :report_id, :status_id, :delivery_method_id, :notes, :pos, :thumb_image_url, :calendar_display, date_ranges_attributes: [:start_date, :end_date, :date_type_id, :id], resources_attributes: [:description, :file]
    )
  end

  def render_error_message
    flash[:error] = @program.errors.full_messages.join(", ")
  end

  def find_program
    @program = Program.find(params[:id])
  end

  def keyword_params
    params.require(:program).permit(:keyword).reject{|i| i if i.blank? }
  end

  def filter_based_on_keyword
    @programs.filter_by_name_or_geography(keyword_params[:keyword])
  end

  def status_params
    params.require(:program).permit(:status).reject{|i| i if i.blank? }
  end

  def filter_based_on_status
    @programs.for_specific_status(status_params[:status])
  end

  def set_date_types
    @date_types = DateType.order("sort_order")
  end

  def build_program_dates
    if @program.persisted?
      current_date_ids = @program.date_ranges.pluck(:date_type_id)
      @date_types.each { |d| @program.date_ranges.build(:date_type_id => d.id) unless current_date_ids.include?(d.id) }
    else
      @date_types.each { |d| @program.date_ranges.build(:date_type_id => d.id) }
    end
  end

  def save_program_dates(date_types_params)
    date_types_params.each do |date_type_param|
      dates = date_type_param.last
      unless dates[:start_date].blank?
        date_range = @program.date_ranges.find_or_create_by(date_type_id: dates[:date_type_id])
        end_date = dates[:end_date].blank? ? "" : Date.strptime(dates[:end_date], "%m/%d/%Y")
        date_range.update_attributes(
          start_date: Date.strptime(dates[:start_date], "%m/%d/%Y"),
          end_date: end_date
        )
      end
    end
  end

  def format_dates_hash
    if params[:program][:date_ranges_attributes]
      @dates = params[:program][:date_ranges_attributes].values
      @dates.map! do |date|
        { :date_type_id => date[:date_type_id],
          :start_date => (Date.strptime(date[:start_date],"%m/%d/%Y") unless date[:start_date].blank?),
          :end_date => (Date.strptime(date[:end_date],"%m/%d/%Y") unless date[:end_date].blank?)
        }
      end
    end
    return @dates
  end

  def set_dates_for_form
    format_dates_hash
    @program.date_ranges.each do |dr|
      date = @dates.detect { |d| d[:date_type_id].to_i == dr.date_type_id } || {}
      dr.assign_attributes(date)
    end
  end

  def assign_geographies_to_programs(geography_ids)
    # Originally this cleared all then readded, but as of Rails 4.2 the next line removes or adds only if needed. No duplicates generated
    @program.geographies = Geography.where(id: geography_ids)
  end

  def assign_color_blocks_to_programs(color_block_ids)
    # Originally this cleared all then readded, but as of Rails 4.2 the next line removes or adds only if needed. No duplicates generated
    @program.color_blocks = ColorBlock.where(id: color_block_ids)
  end

  def program_assets
    if @program
      @dam_assets = @program.dam_assets
        .sort { |p1, p2| asset_parameter(p1, "SKU") <=> asset_parameter(p2, "SKU") }
    else
      @dam_assets = []
    end
  end

end
