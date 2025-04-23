# frozen_string_literal: true

class JerseysController < ApplicationController
  include NextPage::Pagination

  # GET /jerseys
  def index
    paginated_jerseys = paginate_resource(Jersey.all)

    render json: paginated_jerseys
  end

  # GET /jerseys/1
  def show
    @jersey = Jersey.find(params[:id])
    render json: @jersey
  end
end
