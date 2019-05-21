class ColorBlocksController < ApplicationController
  respond_to :html, :js, :json
  before_action :require_user
  load_and_authorize_resource

  add_breadcrumb "Market Category", :color_blocks_path

  def index
    capture_user_hitting_route
    @color_blocks = ColorBlock.all
    @color_block = ColorBlock.new
    respond_with(@color_blocks)
  end

  def new
    capture_user_hitting_route
    @color_block = ColorBlock.new
  end

  def show
    capture_user_hitting_route
  end

  def create
    capture_user_hitting_route
    @color_block = ColorBlock.new(color_block_params)
    unless @color_block.save
      render_error_message
    end
    redirect_to color_blocks_path
  end

  def edit
    capture_user_hitting_route
  end

  def update
    capture_user_hitting_route
    @color_block = ColorBlock.find(params[:id])
    if @color_block.update_attributes(color_block_params)
      flash[:success] = "ColorBlock successfully saved."
    else
      render_error_message
    end
    redirect_to color_blocks_path
  end

  def destroy
    @color_block = ColorBlock.find(params[:id])
    if @color_block.destroy
      redirect_to color_blocks_path
    end
  end

private

  def color_block_params
    params.require(:color_block).permit(:name, :start_hex, :end_hex)
  end

  def render_error_message
    flash[:error] = @color_block.errors.full_messages.join(", ")
  end

  def find_program
    @color_block = ColorBlock.find(params[:id])
  end

end
