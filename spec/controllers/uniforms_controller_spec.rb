# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UniformsController, type: :controller do
  fixtures :jerseys

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
    end

    it 'returns the specified limit' do
      get :index, params: {}
      expect(JSON.parse(response.body).size).to eq 8
    end

    it 'with size: 5' do
      get :index, params: { page: { size: 5 } }
      expect(JSON.parse(response.body).size).to eq 5
    end

    it 'with size 12 and page 2' do
      get :index, params: { page: { size: 12, number: 2 } }
      expect(JSON.parse(response.body).size).to eq 8
    end
  end
end
