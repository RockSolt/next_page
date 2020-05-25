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

    it 'sorts id descending by default' do
      get :index, params: {}
      expect(JSON.parse(response.body).first['id']).to eq Jersey.maximum(:id)
    end

    it 'with sort: number' do
      get :index, params: { sort: 'number' }
      expect(JSON.parse(response.body).first['number']).to eq 1
    end

    it 'with sort: -number' do
      get :index, params: { sort: '-number' }
      expect(JSON.parse(response.body).first['number']).to eq 5
    end

    it 'with sort: number,-home' do
      get :index, params: { sort: 'number,-home' }
      expect(JSON.parse(response.body).first.slice('number', 'home')).to eq('number' => 1, 'home' => true)
    end

    context 'nested sort' do
      fixtures 'teams'

      it 'with sort: team.name' do
        get :index, params: { sort: 'team.name' }
        expect(JSON.parse(response.body).first['team_id']).to eq teams(:aardvarks).id
      end

      it 'with sort: -team.name' do
        get :index, params: { sort: '-team.name' }
        expect(JSON.parse(response.body).first['team_id']).to eq teams(:bears).id
      end
    end

    it 'sorts by scope' do
      get :index, params: { sort: 'popular' }
      expect(JSON.parse(response.body).first.slice('number', 'home')).to eq('number' => 5, 'home' => false)
    end

    it 'with invalid sort attribute' do
      expect { get :index, params: { sort: 'invalid_attribute' } }
        .to raise_exception NextPage::Exceptions::InvalidSortParameter
    end

    it 'with invalid nested sort' do
      expect { get :index, params: { sort: 'team.mascot.color' } }
        .to raise_exception NextPage::Exceptions::InvalidNestedSort
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
