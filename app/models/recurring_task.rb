class RecurringTask < ApplicationRecord
  has_many :tasks, dependent: :nullify

  validates :title, presence: true

  scope :active, -> { where(active: true) }

  before_validation :set_defaults, on: :create

  # Make sure every active daily task exists for `date`, and clean up stale
  # unfinished daily instances from previous days (habits reset each day —
  # they don't pile up in the "à valider" bucket). Idempotent.
  def self.ensure_today!(date = Date.current)
    Task.where.not(recurring_task_id: nil)
        .where(state: :todo)
        .where(day: ...date)
        .delete_all

    active.order(:position, :created_at).each do |rt|
      next if rt.last_added_on == date

      Task.create!(title: rt.title, day: date, recurring_task_id: rt.id)
      rt.update_columns(last_added_on: date)
    end
  end

  private

  def set_defaults
    self.active = true if active.nil?
    self.position ||= (RecurringTask.maximum(:position) || 0) + 1
  end
end
