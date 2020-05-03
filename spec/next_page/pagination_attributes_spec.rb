# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::PaginationAttributes do
  let(:instance) { relation.tap { |cp| cp.extend(described_class) } }

  context 'with limit 5' do
    let(:relation) { Jersey.limit(5) }

    it '#total_pages' do
      expect(instance.total_pages).to eq 4
    end
  end

  context 'with offset 3' do
    let(:relation) { Jersey.offset(3) }

    it '#current_page' do
      expect(instance.current_page).to eq 4
    end

    it '#next_page' do
      expect(instance.next_page).to eq 5
    end
  end
end
