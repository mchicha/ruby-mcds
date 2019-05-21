class Api::V1::UsersController < Api::V1::BaseController
  include HTTParty

  respond_to :json, :html
  skip_before_filter :verify_authenticity_token, only: [:get_claims]
  def index
    @users = User.all.reject{|u| u.email.match('tukaiz.com') || u.email.match('gmail.com') || u.email.match('@net.elmhurst.edu')}
    respond_with @users
  end

  def search
    @users = User.order(:email).where(
      "first_name LIKE ? OR last_name LIKE ? OR email LIKE ?",
      "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%"
    )
    respond_with @users.map{|u| {label: u.email} }, root: false
  end

  def get_claims
    claim_url = CAS_CONFIG["url"]
    # validate the referer
    auth = {username: TkmlAuth.config.basic_auth_user, password: TkmlAuth.config.basic_auth_pass}

    @result = HTTParty.post("#{claim_url}/api/v3/saml/consume",  {
                              body: params.to_json,
                              headers: {"referer"=> request.env["HTTP_HOST"],'x-tkml-auth-token' => TkmlAuth.config.site_token, 'Content-Type'=>'application/json'},
                              basic_auth: auth
                            })

    @user = find_or_create_user(@result)
    if @user
      session[:user_id] = @user.id
    else
      raise 'SSO Failed'.inspect
    end
    redirect_to root_path
  end

  private

    def find_or_create_user(result)
      u = result.to_options[:user]
      user = User.where(cas_user_id: u['id']).first_or_initialize
      if user.new_record?
        user.first_name = u['first_name']
        user.last_name  = u['last_name']
        user.email      = u['email']
        user.skip_remote_callbacks = true
        user.save
      end

      user.valid? ? user : nil
    end
end
