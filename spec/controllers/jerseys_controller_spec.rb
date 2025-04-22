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

    it 'with authentication error on json api request' do
      request.headers.merge!({ Accept: 'application/vnd.api+json' })
      get :index, params: { throw_auth_error: true }
      expect(JSON.parse(response.body)).to eq({ error: 'not authorized', status: 401 }.as_json)
    end

    it 'with non-ActiveRecord response on json api request' do
      request.headers.merge!({ Accept: 'application/vnd.api+json' })
      get :index, params: { contrived_array_example: true }
      expect(JSON.parse(response.body)).to eq([1, 2, 3])
    end
  end
end
