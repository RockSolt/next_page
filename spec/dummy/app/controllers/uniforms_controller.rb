# frozen_string_literal: true

class UniformsController < ApplicationController
  include NextPage::Pagination
  before_action :apply_next_page_pagination, only: :index

  paginate_with instance_variable_name: :unis, model_class: 'Jersey', default_limit: 8

  # GET /uniforms
  def index
    render json: @unis
  end
end
