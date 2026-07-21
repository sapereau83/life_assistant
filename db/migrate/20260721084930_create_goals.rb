class CreateGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :goals do |t|
      t.decimal :target_weight_kg, precision: 5, scale: 2
      t.integer :weekly_workouts, null: false, default: 3
      t.integer :daily_steps
      t.boolean :log_meals_daily, null: false, default: true

      t.timestamps
    end
  end
end
