class CreateWeightEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :weight_entries do |t|
      t.date :recorded_on, null: false
      t.decimal :weight_kg, precision: 5, scale: 2, null: false
      t.string :note

      t.timestamps
    end
    add_index :weight_entries, :recorded_on, unique: true
  end
end
