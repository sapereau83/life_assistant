class AddSkippedFlagsToMeals < ActiveRecord::Migration[8.1]
  def up
    %i[breakfast lunch dinner snacks].each do |meal|
      add_column :meals, :"#{meal}_skipped", :boolean, null: false, default: false
    end

    # Backfill: existing cells whose text is exactly "skipped" become the flag.
    %i[breakfast lunch dinner snacks].each do |meal|
      execute <<~SQL.squish
        UPDATE meals
        SET #{meal}_skipped = TRUE, #{meal} = NULL
        WHERE LOWER(TRIM(#{meal})) = 'skipped'
      SQL
    end
  end

  def down
    %i[breakfast lunch dinner snacks].each do |meal|
      remove_column :meals, :"#{meal}_skipped"
    end
  end
end
