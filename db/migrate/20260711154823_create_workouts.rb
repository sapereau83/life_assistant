class CreateWorkouts < ActiveRecord::Migration[8.1]
  def change
    create_table :workouts do |t|
      t.date :recorded_on, null: false
      t.text :description
      t.integer :duration_minutes
      t.integer :steps

      t.timestamps
    end
    add_index :workouts, :recorded_on, unique: true
  end
end
