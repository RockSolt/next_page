# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::Configuration do
  let(:config) { described_class.new }

  it 'returns 12 when no default_per_page is set' do
    expect(NextPage.configuration.default_per_page).to eq 12
  end

  it 'allows setting a custom default_per_page' do
    NextPage.configuration.default_per_page = 20
    expect(NextPage.configuration.default_per_page).to eq 20
  end

  it 'allows setting a custom default_per_page through the block' do
    NextPage.configure do |config|
      config.default_per_page = 30
    end
    expect(NextPage.configuration.default_per_page).to eq 30
  end
end
