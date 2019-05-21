class LookupTableRowsController < ApplicationController

  before_filter :parse_input_to_hash, only: [:create, :update]

  # load_and_authorize_resource

  def index
    @lookup_table = LookupTable.find(params[:lookup_table_id])
    @lookup_table_rows = @lookup_table.lookup_table_rows.order(:key, :archived)
  end

  def new
    @lookup_table_row = LookupTableRow.new
    @lookup_table = LookupTable.find(params[:lookup_table_id])
    @lookup_table_row.lookup_table = @lookup_table
  end

  def create
    @lookup_table_row = LookupTableRow.new(lookup_table_row_params)
    if @lookup_table_row.save

      redirect_to action: 'show', id: @lookup_table_row.id
    else
      flash[:error] = "Could not save"
      render "new"
    end
  end

  def show
    @lookup_table_row = LookupTableRow.find(params[:id])
  end

  def edit
    @lookup_table = LookupTable.find(params[:lookup_table_id])
    @lookup_table_row = LookupTableRow.find(params[:id])
  end

  def update
    @lookup_table_row = LookupTableRow.find(params[:id])
    if @lookup_table_row.update(lookup_table_row_params)
      render "show"
    else
      flash[:error] = "Could not save"
      render "edit"
    end
  end

  def archive
    @lookup_table_row.update(lookup_table_row_params)
    redirect_to :back
  end


  private

  def lookup_table_row_params
    params.require(:lookup_table_row).permit(:key, :archived, :lookup_table_id, :columns).tap do |while_listed|
      while_listed[:columns] = params[:lookup_table_row][:columns]
    end
  end

  def parse_input_to_hash
    if params[:lookup_table_row] && params[:lookup_table_row][:columns]
      if params[:lookup_table_row][:columns].is_a?(String)
        begin
          params[:lookup_table_row][:columns] = JSON.parse(params[:lookup_table_row][:columns].gsub('=>', ':'))
        rescue  JSON::ParserError => e
          clean_param =  params[:lookup_table_row][:columns].gsub('=>', ':').gsub(/[{|}|"|"]/, '').split(',')
          param_hash = clean_param.inject({}) do |memo, element|
            element = element.split(':').map(&:lstrip)
            memo[element[0]] = element[1]
            memo
          end
          params[:lookup_table_row][:columns] = param_hash
        end
      end
    end
  end

end
