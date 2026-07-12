class WeightEntry < ApplicationRecord
  HEIGHT_CM = 170
  IDEAL_BMI = 22              # widely cited "ideal" BMI (middle of healthy range)
  HEALTHY_BMI = (18.5..24.9)  # normal-weight range

  # Target weight (kg) for the ideal BMI at the configured height.
  def self.ideal_weight = (IDEAL_BMI * height_m**2).round(1)

  # [low, high] weights (kg) for the healthy BMI range.
  def self.healthy_range = [ HEALTHY_BMI.begin, HEALTHY_BMI.end ].map { |b| (b * height_m**2).round(1) }

  def self.height_m = HEIGHT_CM / 100.0

  def bmi = (weight_kg / self.class.height_m**2).round(1)

  validates :recorded_on, presence: true, uniqueness: true
  validates :weight_kg,
            presence: true,
            numericality: { greater_than: 0, less_than: 1000 }

  scope :chronological, -> { order(recorded_on: :asc) }
  scope :recent_first, -> { order(recorded_on: :desc) }

  # Difference (kg) with the previous recorded entry, or nil if it's the first.
  def delta
    prev = WeightEntry.where(recorded_on: ...recorded_on).recent_first.first
    return nil unless prev

    weight_kg - prev.weight_kg
  end
end
