class CreateRecurringTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :recurring_tasks do |t|
      t.string :title, null: false
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0
      t.date :last_added_on

      t.timestamps
    end
  end
end
