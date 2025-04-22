# frozen_string_literal: true

class UniformsController < ApplicationController
  include NextPage::Pagination

  # GET /uniforms
  def index
    @unis = paginate_resource(Jersey.all, default_limit: 8)
    render json: @unis
  end
end
