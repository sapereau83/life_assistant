class AddRecurringTaskRefToTasks < ActiveRecord::Migration[8.1]
  def change
    add_reference :tasks, :recurring_task, null: true, foreign_key: { on_delete: :nullify }
  end
end
