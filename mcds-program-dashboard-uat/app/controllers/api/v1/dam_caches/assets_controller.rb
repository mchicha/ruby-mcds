module Api
  module V1
    module DamCaches
      class AssetsController < ApplicationController
        skip_before_action :verify_authenticity_token, only: :update

        def index
          render json: DamCache.assets
        end

        def clear
          DamCache.clear("assets")
          render json: {message: 'DELETED'}
        end


        def authorization_credentials
          ActionController::HttpAuthentication::Token.encode_credentials(
            DAM_CONFIG['client_token']
          )
        end

        def update
          response = DamCache.send_asset_params(params)
          render json: response.body, status: response.status
        end

        def show
          render json: DamCache.find_asset(params[:id])
        end
      end
    end
  end
end
