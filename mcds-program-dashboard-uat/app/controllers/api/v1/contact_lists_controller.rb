class Api::V1::ContactListsController < Api::V1::BaseController
  before_filter :find_user, only: [:index, :create]
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    @contact_lists = @user.contact_lists
    respond_with @contact_lists.as_json(include: {:contact_list_users => {include: :user}}), root: false
  end

  def create
    @contact_list = ContactList.create(contact_list_params)
    if @contact_list
      params[:users].each do |contact|
        user = User.find(contact["id"])
        @contact_list.users << user
      end
    end
    respond_with @contact_lists, location: nil
  end

  def update
    @contact_list = ContactList.find(params[:id])
    params[:users].uniq.each do |user_params|
      user = User.find(user_params[:id])
      @contact_list.users << user unless @contact_list.users.include?(user)
    end
    respond_with @contact_list.as_json(include: [:contact_list_users, :users]), location: nil
  end

  def destroy
    @contact_list = ContactList.find(params[:id])
    # remove the join records from the contact list
    @contact_list.users.clear
    @contact_list.destroy
    respond_with @contact_list, location: nil
  end

  def show
    @contact_list = ContactList.find(params[:id])
    respond_with @contact_list.as_json(include: {:contact_list_users => {include: :user}}), location: nil
  end

  def search_contact_lists
    if params[:term]
      @contact_lists = ContactList.where(
        "name LIKE ? and user_id = ?", "%#{params[:term]}%", params[:user_id]
      )
      respond_with @contact_lists.map{|cl| {label: cl.name, value: cl.id}}, root: false
    else
      render :nothing => true
    end
  end

  private

  def contact_list_params
    params.require(:contact_list).permit(:name, :user_id)
  end

  def find_user
    @user = User.find(params[:user_id])
  end


end
