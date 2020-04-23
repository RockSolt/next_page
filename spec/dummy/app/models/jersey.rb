# frozen_string_literal: true

class Jersey < ApplicationRecord
  scope :home, -> { where(home: true) }
  scope :away, -> { where(home: false) }
end
