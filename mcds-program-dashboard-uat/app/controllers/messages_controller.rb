class MessagesController < ApplicationController
  respond_to :html, :js
  before_action :require_user

  load_and_authorize_resource param_method: :parsed_message_params

  include SelectableGeographies

  before_filter :check_killswitch
  before_filter :find_root_geographies, only: [:index, :new, :edit]
  before_filter :arranged_selected_geograpgies, only: [:index, :edit, :new]

  autocomplete :user, :email, display_value: :email, full: true

  add_breadcrumb "Messages", :messages_path

  def index
    capture_user_hitting_route
    @message = Message.new
    @messages = Message.viewable_messages(current_user)
    @messages = @messages.order(created_at: :desc)
    @messages = @messages.page(params[:page])
  end

  def new
    if params[:message] && message_params[:delivery_type] == "email"
      @message = Message.new(message_params)
      @message.users = add_recipients_to_message(params[:user_ids], params[:contact_list_ids])
    else
      @message = Message.new
    end

    add_breadcrumb "New Message", new_message_path
  end

  def create
    @message.user_id = current_user.id
    if @message.save
      assign_geographies_to_message(params[:geography_ids] || [])

      if message_params[:delivery_type] == "email"
        @message.users = add_recipients_to_message(params[:user_ids], params[:contact_list_ids])
      end

      assign_resources_to_message(params) if params[:resource_id] && !params[:resource_id].empty?
      flash[:success] = "Message has been successfully created."
      @message.send_email if @message.sent?
    else
      flash[:error] = @message.errors.full_messages.join(", ")
    end
    redirect_user
  end

  def edit
    capture_user_hitting_route
    @resources = @message.resources
    add_breadcrumb "Edit Message", edit_message_path(@message)
  end

  def show
    capture_user_hitting_route
    @resources = @message.resources
    add_breadcrumb "Show Message", message_path(@message)
  end

  def update
    if @message.update_attributes(message_params)
      assign_geographies_to_message(params[:geography_ids] || [])
      assign_resources_to_message(params) if params[:resource_id] && !params[:resource_id].empty?

      if message_params[:delivery_type] == "email"
        @message.users.clear
        @message.users = add_recipients_to_message(params[:user_ids], params[:contact_list_ids])
      end
      flash[:success] = "Message has been successfully updated."
      @message.send_email if @message.sent?
    else
      flash[:error] = @message.errors.full_messages.join(", ")
    end
    redirect_to messages_path
  end

  def destroy
    capture_user_hitting_route
    respond_to do |format|
      format.js
    end
  end

  private

  def find_root_geographies
    @root_geographies = Geography.roots
  end

  def message_params
    @message_params ||= params.require(:message).permit(
      :delivery_type, :publish_date, :archive_date, :sent, :send_date, :subject, :content, resources_attributes: [:file]
    )
  end

  def parsed_message_params
    convert_all_date_options_to_time
    return message_params
  end

  def convert_all_date_options_to_time
    message_params["send_date"] = convert_to_time(message_params[:send_date])
    message_params["publish_date"] = convert_to_time(message_params[:publish_date])
    message_params["archive_date"] = convert_to_time(message_params[:archive_date])
  end

  def convert_to_time(param)
    Time.strptime(param, '%m/%d/%Y %I:%M %p') unless param.blank?
  end

  def assign_geographies_to_message(geography_ids)
    @message.geographies.clear
    geography_ids.each do |geo_id|
      geography = Geography.find(geo_id)
      @message.geographies << geography unless @message.geographies.include?(geography)
    end
  end

  def get_autocomplete_items(params)
    # items = super(params)
    search_term = "%#{params[:term]}%"
    user = params[:model].arel_table
    User.where(user[:email].matches(search_term).or(user[:first_name].matches(search_term)).or(user[:last_name].matches(search_term)))
  end

  def add_recipients_to_message(user_emails, contact_list_ids)
    users = []
    unless user_emails.nil?
      user_emails.each do |user_email|
        if user_email.to_i != 0
          users << User.find(user_email)
        else
          users << User.find_by_email(user_email)
        end
      end
    end

    unless contact_list_ids.nil?
      contact_list_ids.each do |cl|
        users << ContactList.find(cl).users
      end
    end

    users.flatten.uniq
  end

  def assign_resources_to_message(params)
    resource = Resource.find(params[:resource_id])
    new_resource = resource.dup
    new_resource.remote_file_url = resource.file_url
    if new_resource.save
      @message.resources << new_resource
    end
  end

  def redirect_user
    redirect_to messages_path
  end

  def check_killswitch
    unless Killswitch.email_enabled?
      authorize! :manage, :killswitch
    end
  end

end
