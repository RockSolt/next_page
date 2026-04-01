# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage do
  it 'yields Configuration' do
    NextPage.configure do |config|
      expect(config).to be_a NextPage::Configuration
    end
  end

  it 'resets config' do
    before = NextPage.configuration
    NextPage.reset
    after = NextPage.configuration

    expect(before).not_to equal(after)
  end
end
