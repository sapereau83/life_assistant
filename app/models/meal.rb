class Meal < ApplicationRecord
  MEALS = %i[breakfast lunch dinner snacks].freeze

  validates :recorded_on, presence: true, uniqueness: true

  scope :recent_first, -> { order(recorded_on: :desc) }

  # True when nothing was logged for the day (used for the empty hint).
  def blank_day?
    MEALS.all? { |m| self[m].blank? }
  end
end
