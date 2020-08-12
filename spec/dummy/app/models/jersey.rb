# frozen_string_literal: true

class Jersey < ApplicationRecord
  belongs_to :team
  scope :home, -> { where(home: true) }
  scope :away, -> { where(home: false) }
  scope :popular, -> { order(:home, number: :desc) }

  # scopes with prefix and suffix
  scope :sort_by_popular_away, -> { where(home: false).order(number: :desc) }
  scope :popular_away_sort, -> { where(home: false).order(number: :desc) }

  scope :unconventional, ->(_param) { home }

  # scope with direction
  def self.home_numbers(direction)
    home.order(number: direction)
  end
end
