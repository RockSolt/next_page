# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :jerseys
  has_one :coach
end
