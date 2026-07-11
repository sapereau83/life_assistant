# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_11_151922) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.date "day", null: false
    t.integer "position", default: 0, null: false
    t.datetime "rolled_over_at"
    t.integer "state", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["day", "position"], name: "index_tasks_on_day_and_position"
    t.index ["state", "day"], name: "index_tasks_on_state_and_day"
  end

  create_table "weight_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "note"
    t.date "recorded_on", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight_kg", precision: 5, scale: 2, null: false
    t.index ["recorded_on"], name: "index_weight_entries_on_recorded_on", unique: true
  end
end
