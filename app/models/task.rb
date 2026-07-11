class Task < ApplicationRecord
  # todo         -> active on its day, not done yet
  # done         -> completed (stays archived under its day)
  # to_validate  -> rolled over at midnight, waiting in the "à valider" bucket
  enum :state, { todo: 0, done: 1, to_validate: 2 }

  validates :title, presence: true
  validates :day, presence: true

  before_validation :set_defaults, on: :create

  scope :for_day, ->(date) { where(day: date) }
  scope :bucket, -> { to_validate.order(day: :asc, position: :asc) }
  scope :ordered, -> { order(position: :asc, created_at: :asc) }

  # Mark done (or undo) from the daily list.
  def complete!
    update!(state: :done, completed_at: Time.current)
  end

  def reopen!
    update!(state: :todo, completed_at: nil)
  end

  # Pull a task out of the "à valider" bucket back into today's list.
  def move_to_today!
    update!(state: :todo, day: Date.current, rolled_over_at: nil)
  end

  private

  def set_defaults
    self.day ||= Date.current
    self.state ||= :todo
    self.position ||= (Task.for_day(day).maximum(:position) || 0) + 1
  end
end
