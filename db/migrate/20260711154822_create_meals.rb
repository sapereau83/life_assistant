class CreateMeals < ActiveRecord::Migration[8.1]
  def change
    create_table :meals do |t|
      t.date :recorded_on, null: false
      t.text :breakfast
      t.text :lunch
      t.text :dinner
      t.text :snacks

      t.timestamps
    end
    add_index :meals, :recorded_on, unique: true
  end
end
