# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JerseysController, type: :controller do
  fixtures :jerseys

  describe 'GET #index' do
    it 'returns a success response' do
      request.headers.merge!({ Accept: 'application/vnd.api+json' })
      get :index, params: {}
      expect(response).to be_successful
    end

    it 'returns the default limit' do
      get :index, params: {}
      expect(JSON.parse(response.body).size).to eq NextPage::Paginator::DEFAULT_LIMIT
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

  describe 'calling paginate_resource directly' do
    it 'returns a success response' do
      get :home_jerseys, params: {}
      expect(response).to be_successful
    end

    it 'returns a success response' do
      get :home_jerseys, params: { page: { size: 8 } }
      expect(JSON.parse(response.body).size).to eq 8
    end

    it 'with size 4 and page 3' do
      get :home_jerseys, params: { page: { size: 4, number: 3 } }
      expect(JSON.parse(response.body).size).to eq 2
    end
  end
end
