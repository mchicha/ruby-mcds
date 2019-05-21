class ResourcesController < ApplicationController
  before_action :set_program, only: [:create, :update]
  before_action :set_resource, only: [:show, :update, :destroy]

  def create
    capture_user_hitting_route
    @resource = Resource.new(resource_params)
    @resource.resourceable = @program

    respond_to do |format|
      if @resource.save
        format.js { render 'resources/create' }
      else
        format.js { render 'resources/failed_validation' }
      end
    end
  end

  def update
    capture_user_hitting_route
    respond_to do |format|
      if @resource.update_attributes(resource_params)
        format.js { render 'resources/update' }
      else
        format.js { render 'resources/failed_validation' }
      end
    end
  end

  def show
    capture_user_hitting_route
    respond_to do |format|
      format.html { redirect_to @resource.file.url }
      format.js
    end
  end

  def destroy
    capture_user_hitting_route
    # remove file from S3 bucket first
    @resource.remove_file!
    # delete the resource object
    @resource.destroy
    respond_to do |format|
      format.js
    end
  end

  private

    def resource_params
      params.require(:resource).permit(:description, :file, :id)
    end

    def set_resource
      @resource = Resource.find(params[:id])
    end

    def set_program
      @program = Program.find(params[:program_id])
    end

end
