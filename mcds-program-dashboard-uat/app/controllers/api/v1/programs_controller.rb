class Api::V1::ProgramsController < ApplicationController

  before_filter :selected_geographies

  respond_to :json

  def index
    render json: rendered_json
  end

  def rendered_json
    # string is weird due to how redis looks stuff up. the more
    key_string = "p#{@selected_geography_ids}-#{params['popStartDate'][0..9]}-#{params['popEndDate'][0..9]}"
    cached = Redis.current.get(key_string)

    if !cached
      cached = {programs: generate_json}
      Redis.current.setex(key_string, 900, cached.to_json)
    end

    cached
  end

  def generate_json
    @programs = Program.for_specific_coops_and_national(@selected_geography_ids).
      date_ranges_for_types(start_date: params["popStartDate"], end_date: params["popEndDate"], date_types: ['pop_install'])

    ActiveModel::ArraySerializer.new(
      @programs.preload(:color_blocks, :geographies),
      each_serializer: ProgramSerializer
    )
  end

  def show
    @program = Program.find(params[:id])

    render json: @program
  end

end
