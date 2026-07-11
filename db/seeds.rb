# Idempotent seed data. Run with: bin/rails db:seed

# --- Weight history imported from Notion (Daily Weight Tracker) ---
# The "???" entry (2026-02-22) is skipped; duplicate dates keep the first value.
weight_history = {
  "2026-02-08" => 95.5, "2026-02-09" => 95.0, "2026-02-10" => 95.0,
  "2026-02-11" => 95.2, "2026-02-12" => 94.6, "2026-02-13" => 94.7,
  "2026-02-14" => 94.3, "2026-02-15" => 94.7, "2026-02-19" => 93.3,
  "2026-02-20" => 94.0, "2026-02-21" => 92.4, "2026-02-23" => 92.6,
  "2026-02-24" => 92.8, "2026-02-25" => 92.6, "2026-02-26" => 91.9,
  "2026-02-27" => 91.1, "2026-02-28" => 90.6, "2026-03-01" => 90.8,
  "2026-03-02" => 90.8, "2026-03-03" => 90.5, "2026-03-04" => 90.3,
  "2026-03-05" => 89.9, "2026-03-06" => 89.7, "2026-03-07" => 89.4,
  "2026-03-08" => 89.9, "2026-03-09" => 89.9, "2026-03-10" => 89.3,
  "2026-03-11" => 88.4, "2026-03-12" => 88.1, "2026-03-13" => 88.0,
  "2026-03-14" => 87.5, "2026-03-15" => 87.1, "2026-03-16" => 86.3,
  "2026-03-17" => 86.1, "2026-03-18" => 85.9, "2026-03-19" => 85.9,
  "2026-03-20" => 85.9, "2026-03-21" => 85.9, "2026-03-22" => 85.9,
  "2026-03-23" => 85.9, "2026-03-24" => 85.9, "2026-03-25" => 87.8,
  "2026-03-26" => 87.9
}

weight_history.each do |date, kg|
  entry = WeightEntry.find_or_initialize_by(recorded_on: Date.parse(date))
  entry.update!(weight_kg: kg)
end

puts "Seeded #{WeightEntry.count} weight entries."

# --- A couple of example tasks for today so the daily list isn't empty ---
if Task.for_day(Date.current).none?
  [ "Boire 2L d'eau", "Marcher 10 000 pas", "Coder 1h sur le life assistant" ].each do |title|
    Task.create!(title: title)
  end
  puts "Seeded #{Task.for_day(Date.current).count} sample tasks for today."
end
