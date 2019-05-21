class Api::V1::ContactListUsersController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def show
    @contact_list_user = ContactListUser.find(params[:id])
    respond_with @contact_list_user.as_json, location: nil
  end

  def destroy
    @contact_list_user = ContactListUser.find(params[:id])
    @contact_list_user.destroy
    respond_with @contact_list_user, location: nil
  end

  private

  def contact_list_user_params
    params.require(:contact_list_user).permit(:contact_list_id, :user_id)
  end

end
