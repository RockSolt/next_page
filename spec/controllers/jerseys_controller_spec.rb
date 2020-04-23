# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JerseysController, type: :controller do
  fixtures :jerseys

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_successful
    end

    it 'returns 20 jerseys' do
      get :index, params: {}
      expect(JSON.parse(response.body).size).to eq 20
    end

    it 'returns 10 when filtered to home' do
      get :index, params: { filter: { home: true } }
      expect(JSON.parse(response.body).size).to eq 10
    end
  end
end
