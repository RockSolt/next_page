# frozen_string_literal: true

class JerseysController < ApplicationController
  # GET /jerseys
  def index
    @jerseys = Jersey.all

    @jerseys = @jerseys.home if params.dig(:filter, :home)
    @jerseys = @jerseys.away if params.dig(:filter, :away)

    render json: @jerseys
  end

  # GET /jerseys/1
  def show
    @jersey = Jersey.find(params[:id])
    render json: @jersey
  end
end
