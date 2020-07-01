# frozen_string_literal: true

class JerseysController < ApplicationController
  before_action :authenticate_user, only: :index
  before_action :render_array, only: :index
  include NextPage::Pagination
  before_action :apply_next_page_pagination, only: :index

  # GET /jerseys
  def index
    @jerseys = @jerseys.home if params.dig(:filter, :home)
    @jerseys = @jerseys.away if params.dig(:filter, :away)

    # render with json_api to test the total_pages attribute
    render json: @jerseys
  end

  # GET /jerseys/1
  def show
    @jersey = Jersey.find(params[:id])
    render json: @jersey
  end

  def home_jerseys
    @jerseys = paginate_resource(Jersey.home)
    render json: @jerseys
  end

  private

  # example of rendering a non-ActiveRecord
  def authenticate_user
    return unless params.fetch('throw_auth_error', false) == 'true'

    render json: { error: 'not authorized', status: 401 }.as_json
  end

  def render_array
    return unless params.fetch('contrived_array_example', false) == 'true'

    render json: [1, 2, 3]
  end
end
