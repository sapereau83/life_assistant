class WeightEntry < ApplicationRecord
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
