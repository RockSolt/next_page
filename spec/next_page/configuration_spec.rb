# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::Configuration do
  let(:config) { described_class.new }

  it 'returns 12 when no default_per_page is set' do
    expect(config.default_per_page).to eq 12
  end

  it 'allows setting a custom default_per_page' do
    config.default_per_page = 20
    expect(config.default_per_page).to eq 20
  end
end
