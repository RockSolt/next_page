# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::Configuration do
  let(:config) { described_class.new }

  it '#scope_sort_prefix= converts to string' do
    config.sort_scope_prefix = :sort_by_
    expect(config.sort_scope_prefix).to eq 'sort_by_'
  end

  context '#scope_sort_prefix?' do
    it 'false by default' do
      expect(config.sort_scope_prefix?).to be false
    end

    it 'true when populated' do
      config.sort_scope_prefix = 'sort_by_'
      expect(config.sort_scope_prefix?).to be true
    end
  end

  it '#scope_sort_suffix= converts to string' do
    config.sort_scope_suffix = :_sort
    expect(config.sort_scope_suffix).to eq '_sort'
  end

  context '#scope_sort_suffix?' do
    it 'false by default' do
      expect(config.sort_scope_suffix?).to be false
    end

    it 'true when populated' do
      config.sort_scope_suffix = '_sort'
      expect(config.sort_scope_suffix?).to be true
    end
  end
end
