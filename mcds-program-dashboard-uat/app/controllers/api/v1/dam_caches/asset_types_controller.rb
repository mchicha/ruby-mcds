module Api
  module V1
    module DamCaches
      class AssetTypesController < ApplicationController
        def index
          render json: DamCache.asset_types
        end


        def show
          render json: DamCache.find_asset_type(params[:id])
        end

        def clear
          DamCache.clear("types")
          render json: {message: 'DELETED'}
        end
      end
    end
  end
end
