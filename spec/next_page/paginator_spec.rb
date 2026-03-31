# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::Paginator do
  subject(:paginator) { described_class.new }

  let(:relation)      { Jersey.all }
  let(:result)        { paginator.paginate_resource(relation, params, default_limit) }
  let(:params)        { {} }
  let(:default_limit) { nil }

  describe '#paginate_resource' do
    context 'with no params and no default_limit' do
      it 'extends the relation with PaginationAttributes' do
        expect(result).to respond_to(:per_page)
        expect(result).to respond_to(:current_page)
        expect(result).to respond_to(:next_page)
        expect(result).to respond_to(:previous_page)
        expect(result).to respond_to(:total_count)
        expect(result).to respond_to(:total_pages)
      end

      it 'defaults per_page to the configured default_per_page' do
        expect(result.per_page).to eq NextPage.configuration.default_per_page
      end

      it 'defaults current_page to 1' do
        expect(result.current_page).to eq 1
      end

      it 'applies limit from default_per_page' do
        expect(result.limit_value).to eq NextPage.configuration.default_per_page
      end

      it 'applies an offset of 0 for page 1' do
        expect(result.offset_value).to eq 0
      end
    end

    context 'with params[:size] and params[:number]' do
      let(:params) { { size: '5', number: '3' } }

      it 'sets per_page from params[:size]' do
        expect(result.per_page).to eq 5
      end

      it 'sets current_page from params[:number]' do
        expect(result.current_page).to eq 3
      end

      it 'applies the correct limit' do
        expect(result.limit_value).to eq 5
      end

      it 'applies the correct offset for page 3' do
        expect(result.offset_value).to eq 10
      end
    end

    context 'with an explicit default_limit' do
      let(:default_limit) { 8 }

      it 'uses the explicit default_limit for per_page' do
        expect(result.per_page).to eq 8
      end

      it 'applies the correct limit' do
        expect(result.limit_value).to eq 8
      end

      it 'applies an offset of 0 for page 1' do
        expect(result.offset_value).to eq 0
      end
    end

    context 'when params[:size] is present alongside a default_limit' do
      let(:params)        { { size: '5' } }
      let(:default_limit) { 8 }

      it 'prefers params[:size] over the default_limit' do
        expect(result.per_page).to eq 5
        expect(result.limit_value).to eq 5
      end
    end

    context 'with invalid params[:number] of 0' do
      let(:params) { { size: '5', number: '0' } }

      it 'coerces current_page to 1' do
        expect(result.current_page).to eq 1
      end

      it 'applies an offset of 0' do
        expect(result.offset_value).to eq 0
      end
    end

    context 'with a negative params[:number]' do
      let(:params) { { size: '5', number: '-3' } }

      it 'coerces current_page to 1' do
        expect(result.current_page).to eq 1
      end

      it 'applies an offset of 0' do
        expect(result.offset_value).to eq 0
      end
    end

    context 'with invalid params[:size] of 0' do
      let(:params) { { size: '0', number: '1' } }

      it 'coerces per_page to 1' do
        expect(result.per_page).to eq 1
        expect(result.limit_value).to eq 1
      end
    end

    context 'with a negative params[:size]' do
      let(:params) { { size: '-5', number: '1' } }

      it 'coerces per_page to 1' do
        expect(result.per_page).to eq 1
        expect(result.limit_value).to eq 1
      end
    end
  end
end
