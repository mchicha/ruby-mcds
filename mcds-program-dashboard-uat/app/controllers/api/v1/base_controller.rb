module Api::V1
  class BaseController < ActionController::Base
    protect_from_forgery with: :null_session
    respond_to :json

    # http_basic_authenticate_with(
    # name:     AUTH_CONFIG[:name],
    # password: AUTH_CONFIG[:password]
    # )
  end
end
