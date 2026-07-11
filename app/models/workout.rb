class Workout < ApplicationRecord
  validates :recorded_on, presence: true, uniqueness: true
  validates :duration_minutes, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :steps, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  scope :recent_first, -> { order(recorded_on: :desc) }
  scope :chronological, -> { order(recorded_on: :asc) }

  # Whether any real activity was logged (a "nothing"/blank day doesn't count).
  def active?
    description.present? && description.strip.downcase != "nothing"
  end
end
