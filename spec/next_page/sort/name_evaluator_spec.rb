# frozen_string_literal: true

require 'rails_helper'
require 'next_page/sort/name_evaluator'

RSpec.describe NextPage::Sort::NameEvaluator do
  context 'with attribute' do
    let(:evaluator) { described_class.new(Jersey, :number) }

    it('#scope?') { expect(evaluator.scope?).to be false }
    it('#valid_attribute_name?') { expect(evaluator.valid_attribute_name?).to be true }
  end

  context 'with scope' do
    let(:evaluator) { described_class.new(Jersey, :popular) }

    it('#scope?') { expect(evaluator.scope?).to be true }
    it('#scope_name') { expect(evaluator.scope_name).to eq 'popular' }
  end

  context 'with scope that matches attribute name' do
    let(:evaluator) { described_class.new(Jersey, :home) }

    it('#scope?') { expect(evaluator.scope?).to be true }
    it('#scope_name') { expect(evaluator.scope_name).to eq 'home' }
  end

  context 'with invalid name' do
    let(:evaluator) { described_class.new(Jersey, :not_a_thing) }

    it('#scope?') { expect(evaluator.scope?).to be false }
    it('#valid_attribute_name?') { expect(evaluator.valid_attribute_name?).to be false }
  end

  context 'with prefix' do
    before do
      NextPage.reset
      NextPage.configure { |config| config.sort_scope_prefix = :sort_by_ }
    end

    after { NextPage.reset }

    describe 'non-prefixed scope still works' do
      let(:evaluator) { described_class.new(Jersey, :popular) }

      it('#scope?') { expect(evaluator.scope?).to be true }
      it('#scope_name') { expect(evaluator.scope_name).to eq 'popular' }
    end

    describe 'sort_by_popular_away' do
      let(:evaluator) { described_class.new(Jersey, :popular_away) }

      it('#scope?') { expect(evaluator.scope?).to be true }
      it('#scope_name') { expect(evaluator.scope_name).to eq 'sort_by_popular_away' }
    end
  end

  context 'with suffix' do
    before do
      NextPage.reset
      NextPage.configure { |config| config.sort_scope_suffix = '_sort' }
    end

    after { NextPage.reset }

    describe 'non-prefixed scope still works' do
      let(:evaluator) { described_class.new(Jersey, :popular) }

      it('#scope?') { expect(evaluator.scope?).to be true }
      it('#scope_name') { expect(evaluator.scope_name).to eq 'popular' }
    end

    describe 'popular_away_sort' do
      let(:evaluator) { described_class.new(Jersey, :popular_away) }

      it('#scope?') { expect(evaluator.scope?).to be true }
      it('#scope_name') { expect(evaluator.scope_name).to eq 'popular_away_sort' }
    end
  end
end
