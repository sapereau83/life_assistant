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

# --- Exercise history imported from Notion (Daily Exercise Tracker) ---
# [description, duration_minutes, steps]. Sick days (2026-03-19..27) are skipped.
workout_history = {
  "2026-02-08" => [ "kettlebell (x60)\nfootball exercices\nbasketball shoots", 10, 3264 ],
  "2026-02-09" => [ "kettlebell (x40)", 10, 7483 ],
  "2026-02-10" => [ "kettlebell\nbasketball shoots", 10, 10646 ],
  "2026-02-11" => [ "nothing", nil, 6809 ],
  "2026-02-12" => [ "vélo", 20, 8948 ],
  "2026-02-13" => [ "marche rapide", 10, 9612 ],
  "2026-02-14" => [ "vélo", 10, 8668 ],
  "2026-02-15" => [ "kettlebell", 5, 7286 ],
  "2026-02-19" => [ "kettlebell", 10, 6233 ],
  "2026-02-20" => [ "kettlebell\n2x10 burpees\n1 mn plank", 15, 15000 ],
  "2026-02-21" => [ "vélo", 20, 11369 ],
  "2026-02-22" => [ "nothing", nil, 6000 ],
  "2026-02-23" => [ "vélo", 10, 10000 ],
  "2026-02-24" => [ "nothing", nil, 9382 ],
  "2026-02-25" => [ "nothing", nil, 9462 ],
  "2026-02-26" => [ "vélo", 10, 9130 ],
  "2026-02-27" => [ "marche rapide", 10, 10000 ],
  "2026-02-28" => [ "vélo", 10, 14000 ],
  "2026-03-01" => [ "nothing", nil, 10174 ],
  "2026-03-02" => [ "vélo", 20, 16549 ],
  "2026-03-03" => [ "vélo", 20, 16395 ],
  "2026-03-04" => [ "vélo", 20, 14590 ],
  "2026-03-05" => [ "vélo", 20, 16979 ],
  "2026-03-06" => [ "vélo", 20, 20102 ],
  "2026-03-07" => [ "vélo", 10, 11194 ],
  "2026-03-08" => [ "vélo", 10, 14360 ],
  "2026-03-09" => [ "vélo", 10, 11000 ],
  "2026-03-10" => [ "vélo", 10, 12004 ],
  "2026-03-11" => [ "nothing", nil, 7343 ],
  "2026-03-12" => [ "foot", 20, 11680 ],
  "2026-03-13" => [ "nothing", nil, 7000 ],
  "2026-03-14" => [ "nothing", nil, 7000 ],
  "2026-03-15" => [ "nothing", nil, 2900 ],
  "2026-03-16" => [ "foot", 20, 8995 ],
  "2026-03-17" => [ "foot", 20, 7000 ],
  "2026-03-18" => [ "vélo", 20, 9025 ]
}

workout_history.each do |date, (desc, mins, steps)|
  w = Workout.find_or_initialize_by(recorded_on: Date.parse(date))
  w.update!(description: desc, duration_minutes: mins, steps: steps)
end
puts "Seeded #{Workout.count} workouts."

# --- Meal history imported from Notion (Daily Meal Tracker) ---
# [breakfast, lunch, dinner, snacks]; blank cells become nil.
meal_history = {
  "2026-02-08" => [ "skipped", "chicken curry\nbowl of rice\nA glass Cola\nbirthday cake", "chicken curry\nbowl of rice", "4 nuts" ],
  "2026-02-09" => [ "skipped", "chicken curry\nbowl of rice\n2 cookies", "chicken curry\nbowl of rice\n5 candies", "2 nuts" ],
  "2026-02-10" => [ "un pain au chocolat", "un pain au lait\nun bol de riz", "frites 100g\n3 tenders\n2 oeufs\n4 candies", "nothing" ],
  "2026-02-11" => [ "un croissant", "2 part de lasagnes\n2 verre de cola", "2 part de lasagne", "5 bonbons" ],
  "2026-02-12" => [ "un croissant\nun oeuf dur", "un part de lasagne\nun croissant", "3 parts de pizza\ndes frites\nsauce samourai", "8 bonbons" ],
  "2026-02-13" => [ "croissant\nbanane", "bol de riz cantoné", "2 parts de pizza\ndes frites\nun verre de cola", "4 bonbons\npack de gateau" ],
  "2026-02-14" => [ "croissant", "tacos\nfrite", "hot dog\nfrites\njus", "6 bonbons" ],
  "2026-02-15" => [ "skipped", "hotpot\ncola", "", "hot chocolate\n2 pains au choco" ],
  "2026-02-19" => [ "banane\npain choco\nthé", "skipped", "2 assiettes de pate\nfrites sauce Algérienne", "4 bonbons" ],
  "2026-02-20" => [ "banane\nsandwich confiture", "skipped", "3 tough eggs\nun peu de salade", "2 bonbons" ],
  "2026-02-21" => [ "skipped", "skipped", "kebab\nfrites\njus de mangues", "" ],
  "2026-02-22" => [ "kebab leftovers", "skipped", "3 assiettes de pates\n2 verres de cola", "4 pains au lait\n2 yaourts\n1 paquet de chips" ],
  "2026-02-23" => [ "skipped", "skipped", "omelette espagnole\nverre de coca", "3 pains au lait\n1 cuillère de confiture\n1 nougat\n1 banane" ],
  "2026-02-24" => [ "skipped", "skipped", "tacos maison merguez\nchips\n2 verre cola", "2 pain au lait\n2 ferrero rocher" ],
  "2026-02-25" => [ "skipped", "skipped", "un part de pizza\nfrites\n3 spoons ice cream", "1 pain au lait\nbanane" ],
  "2026-02-26" => [ "skipped", "skipped", "pates\npetit sandwich Philadelphia", "1 banane" ],
  "2026-02-27" => [ "skipped", "skipped", "1 tacos et demi vapeur\n1 verre de cola\n15g chips", "1 banane\n3 pains au lait" ],
  "2026-02-28" => [ "skipped", "skipped", "1 sandwich thon/mayo\n1 paquet de chips\n1 verre de cola", "1 banane" ],
  "2026-03-01" => [ "skipped", "skipped", "1 assiette de pate\nrestes de frite five guys\n2 petits verres Ice Tea", "1 lion\n1 date" ],
  "2026-03-02" => [ "skipped", "skipped", "1 petite part de pizza\n6 dattes\n1 banane\n1 petit de ice tea", "2 banane\n1 lion" ],
  "2026-03-03" => [ "4 dattes", "skipped", "10 raviolis chinoises\n4 sweet rice balls", "1 banane\n20g de 3D buggles\n1 lion" ],
  "2026-03-04" => [ "4 dattes", "skipped", "10 raviolis chinoise\nun fond de ice tea\n1 datte", "mini bol de 3D buggles\n1 lion\n1/2 banane" ],
  "2026-03-05" => [ "4 dattes", "skipped", "un bol de pates\n20g de 3D buggles\n1 yaourt nature sucré", "10 g de 3D buggles\n1 lion" ],
  "2026-03-06" => [ "3 dattes", "skipped", "un burger et demi\ndes frites cheddar\n2 cannettes de soda\n1/2 tartelette au citron", "" ],
  "2026-03-07" => [ "1 lion", "skipped", "un demi kebab\n20g de 3D buggles\n1 verre de cola", "1 lion" ],
  "2026-03-08" => [ "skipped", "skipped", "un tacos\ndes frites\n3 petits verres de cola", "20g de 3D buggles\n1 lion" ],
  "2026-03-09" => [ "lion", "skipped", "bol de pate\n1 verre cola", "" ],
  "2026-03-10" => [ "banane", "skipped", "skipped (vomissement)", "" ],
  "2026-03-11" => [ "banane", "skipped", "skipped (vomissement)", "" ],
  "2026-03-12" => [ "banane", "skipped", "salade\n2 pains au lait\nun verre jus de mangue", "1 banane" ],
  "2026-03-13" => [ "skipped", "skipped", "tacos poulet\nfrite", "" ],
  "2026-03-14" => [ "skipped", "skipped", "pizza", "" ],
  "2026-03-15" => [ "skipped", "skipped", "pizza\ntacos", "" ],
  "2026-03-16" => [ "banane", "skipped", "salad\nbol de cereale\nlion", "" ],
  "2026-03-17" => [ "banane", "skipped", "un bol de cereale", "" ],
  "2026-03-18" => [ "banane", "skipped", "un tacos\n1 demi paquet de chips\nun verre de cola", "" ]
}
# Sick stretch: everything logged as "sick".
("2026-03-19".to_date.."2026-03-27".to_date).each do |d|
  meal_history[d.to_s] = %w[sick sick sick sick]
end

meal_history.each do |date, (b, l, di, s)|
  m = Meal.find_or_initialize_by(recorded_on: Date.parse(date))
  m.update!(breakfast: b.presence, lunch: l.presence, dinner: di.presence, snacks: s.presence)
end
puts "Seeded #{Meal.count} meal days."

# --- A couple of example tasks for today so the daily list isn't empty ---
if Task.for_day(Date.current).none?
  [ "Boire 2L d'eau", "Marcher 10 000 pas", "Coder 1h sur le life assistant" ].each do |title|
    Task.create!(title: title)
  end
  puts "Seeded #{Task.for_day(Date.current).count} sample tasks for today."
end
