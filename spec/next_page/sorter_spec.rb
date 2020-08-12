# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NextPage::Sorter do
  let(:sorter) { described_class.new(Jersey) }

  context 'with model attribute' do
    it 'number' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['number'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '+number' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['number'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '-number' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['number'].desc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it 'caches result' do
      sorter.sort(Jersey, 'number')
      cache = sorter.instance_variable_get('@cache')
      expect(cache.keys).to include('number')
      expect(cache['number']).to be_a Proc
    end

    it 'uses cached result' do
      sorter.sort(Jersey, 'number')
      expect(ActiveSupport::Notifications).not_to receive(:instrument)
      sorter.sort(Jersey, 'number')
    end
  end

  context 'with nested attribute' do
    it 'team.name' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(:team)
      expect(query.to_sql).to include Team.arel_table['name'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '+team.name' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(:team)
      expect(query.to_sql).to include Team.arel_table['name'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '-team.name' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(:team)
      expect(query.to_sql).to include Team.arel_table['name'].desc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it 'team.coach.name' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(team: :coach)
      expect(query.to_sql).to include Coach.arel_table['name'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '+team.coach.name' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(team: :coach)
      expect(query.to_sql).to include Coach.arel_table['name'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '-team.coach.name' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(team: :coach)
      expect(query.to_sql).to include Coach.arel_table['name'].desc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end
  end

  context 'with scope' do
    it 'popular' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['home'].asc.to_sql
      expect(query.to_sql).to include Jersey.arel_table['number'].desc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end
  end

  context 'with nested scope' do
    it 'team.popular_names' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.joins_values).to contain_exactly(:team)
      expect(query.to_sql).to include Team.arel_table['name'].desc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end
  end

  context 'with nested directional scope' do
    it 'home_numbers' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['number'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '+home_numbers' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['number'].asc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end

    it '-home_numbers' do |x|
      query = sorter.sort(Jersey, x.description)
      expect(query.to_sql).to include Jersey.arel_table['number'].desc.to_sql
      expect { query.explain }.not_to raise_exception, "Invalid SQL: #{query.to_sql}"
    end
  end
end
