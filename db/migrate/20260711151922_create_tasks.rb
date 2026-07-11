class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.integer :state, null: false, default: 0
      t.date :day, null: false
      t.integer :position, null: false, default: 0
      t.datetime :completed_at
      t.datetime :rolled_over_at

      t.timestamps
    end
    add_index :tasks, [ :state, :day ]
    add_index :tasks, [ :day, :position ]
  end
end
