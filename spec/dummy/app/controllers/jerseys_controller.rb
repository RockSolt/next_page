# frozen_string_literal: true

class JerseysController < ApplicationController
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
end
