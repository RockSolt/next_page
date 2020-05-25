# frozen_string_literal: true

class Jersey < ApplicationRecord
  belongs_to :team
  scope :home, -> { where(home: true) }
  scope :away, -> { where(home: false) }
  scope :popular, -> { order(:home, number: :desc) }
end
