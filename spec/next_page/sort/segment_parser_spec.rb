# frozen_string_literal: true

require 'rails_helper'
require 'next_page/sort/segment_parser'

RSpec.describe NextPage::Sort::SegmentParser do
  it 'number' do |x|
    segment = described_class.new(x.description)
    expect(segment.nested?).to be false
    expect(segment.direction).to eq 'asc'
    expect(segment.name).to eq 'number'
    expect(segment.attribute_with_direction).to eq({ 'number' => 'asc' })
  end

  it '+number' do |x|
    segment = described_class.new(x.description)
    expect(segment.nested?).to be false
    expect(segment.direction).to eq 'asc'
    expect(segment.name).to eq 'number'
    expect(segment.attribute_with_direction).to eq({ 'number' => 'asc' })
  end

  it '-number' do |x|
    segment = described_class.new(x.description)
    expect(segment.nested?).to be false
    expect(segment.direction).to eq 'desc'
    expect(segment.name).to eq 'number'
    expect(segment.attribute_with_direction).to eq({ 'number' => 'desc' })
  end

  it 'team.coach.name' do |x|
    segment = described_class.new(x.description)
    expect(segment.nested?).to be true
    expect(segment.associations).to contain_exactly('team', 'coach')
    expect(segment.direction).to eq 'asc'
    expect(segment.name).to eq 'name'
    expect(segment.attribute_with_direction).to eq({ 'name' => 'asc' })
  end

  it '+team.coach.name' do |x|
    segment = described_class.new(x.description)
    expect(segment.nested?).to be true
    expect(segment.associations).to contain_exactly('team', 'coach')
    expect(segment.direction).to eq 'asc'
    expect(segment.name).to eq 'name'
    expect(segment.attribute_with_direction).to eq({ 'name' => 'asc' })
  end

  it '-team.coach.name' do |x|
    segment = described_class.new(x.description)
    expect(segment.nested?).to be true
    expect(segment.associations).to contain_exactly('team', 'coach')
    expect(segment.direction).to eq 'desc'
    expect(segment.name).to eq 'name'
    expect(segment.attribute_with_direction).to eq({ 'name' => 'desc' })
  end
end
