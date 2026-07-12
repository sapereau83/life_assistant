class Meal < ApplicationRecord
  MEALS = %i[breakfast lunch dinner snacks].freeze

  validates :recorded_on, presence: true, uniqueness: true

  before_save :clear_skipped_content

  scope :recent_first, -> { order(recorded_on: :desc) }

  def skipped?(meal) = self["#{meal}_skipped"]

  # Content split into clean bullet items (one per non-blank line), with any
  # leading bullet/dash characters stripped so we never double up.
  def items(meal)
    return [] if skipped?(meal)

    self[meal].to_s.split("\n").map { |line| line.sub(/\A\s*[•\-*]\s*/, "").strip }.reject(&:blank?)
  end

  # True when nothing was logged for the day (no content and nothing skipped).
  def blank_day?
    MEALS.all? { |m| !skipped?(m) && self[m].blank? }
  end

  private

  # A skipped meal never keeps free-text content.
  def clear_skipped_content
    MEALS.each { |m| self[m] = nil if skipped?(m) }
  end
end
