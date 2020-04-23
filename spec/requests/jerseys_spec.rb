# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jerseys', type: :request do
  describe 'GET /jerseys' do
    it 'works! (now write some real specs)' do
      get jerseys_path
      expect(response).to have_http_status(200)
    end
  end
end
