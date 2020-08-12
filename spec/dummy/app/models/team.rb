# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :jerseys
  has_one :coach

  # doesn't make much sense as a named scope, but allows for easy testing
  scope :popular_names, -> { order(name: :desc) }
end
