# Single-row settings holding the user's targets. Use Goal.current everywhere;
# it lazily creates the one row with sensible defaults.
class Goal < ApplicationRecord
  validates :weekly_workouts, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :target_weight_kg, numericality: { greater_than: 0, less_than: 1000 }, allow_nil: true
  validates :daily_steps, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true

  def self.current
    first || create!
  end

  # Falls back to the BMI-derived ideal weight when no explicit target is set.
  def effective_target_weight
    target_weight_kg || WeightEntry.ideal_weight
  end
end
