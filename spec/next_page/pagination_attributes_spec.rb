# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::PaginationAttributes do
  let(:instance) { relation.tap { |cp| cp.extend(described_class) } }

  context 'with limit 5' do
    let(:relation) { Jersey.limit(6) }

    it '#previous_page' do
      expect(instance.previous_page).to be_nil
    end

    it '#total_count' do
      expect(instance.total_count).to eq 20
    end

    it '#total_pages' do
      expect(instance.total_pages).to eq 4
    end
  end

  context 'with offset 3' do
    let(:relation) { Jersey.offset(3).limit(5) }

    it '#previous_page' do
      expect(instance.previous_page).to eq 3
    end

    it '#current_page' do
      expect(instance.current_page).to eq 4
    end

    it '#next_page' do
      expect(instance.next_page).to be_nil
    end

    it '#total_pages' do
      expect(instance.total_pages).to eq 4
    end
  end

  context 'with count_query' do
    let(:relation) { Jersey.offset(3).limit(5) }
    before { instance.count_query = Jersey.limit(6) }

    it '#total_count' do
      expect(instance.total_count).to eq 20
    end

    it '#total_pages' do
      expect(instance.total_pages).to eq 4
    end
  end

  context 'with manually provided attributes' do
    let(:relation) { Jersey.offset(3).limit(5) }

    before do
      instance.current_page = 10
      instance.total_count = 123
      instance.per_page = 4
    end

    it '#current_page' do
      expect(instance.current_page).to eq 10
    end

    it '#next_page' do
      expect(instance.next_page).to eq 11
    end

    it '#total_pages' do
      expect(instance.total_pages).to eq 31
    end
  end
end
