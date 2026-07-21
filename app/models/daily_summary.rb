# Plain Ruby object that answers "how well is today captured?" across the four
# trackers (tasks, weight, meals, workout). Powers the dashboard hero card so
# you see at a glance what's done and what's still to log.
class DailySummary
  # `icon` is an IconsHelper key; `anchor` is the id of the matching section on
  # the "Aujourd'hui" page so every row jumps to the right place to fill it in.
  Item = Struct.new(:key, :label, :icon, :done, :detail, :anchor, keyword_init: true)

  def initialize(today: Date.current)
    @today = today
  end

  def items
    @items ||= [ tasks_item, weight_item, meals_item, workout_item ]
  end

  def total = items.size
  def done_count = items.count(&:done)
  def complete? = done_count == total
  def percent = total.zero? ? 0 : ((done_count.to_f / total) * 100).round
  def pending = items.reject(&:done)

  private

  def tasks_item
    tasks = Task.for_day(@today).where(state: %i[todo done]).to_a
    remaining = tasks.count(&:todo?)
    detail =
      if tasks.empty? then "Aucune tâche"
      elsif remaining.zero? then "Tout est fait"
      else "#{remaining} restante#{'s' if remaining > 1} / #{tasks.size}"
      end
    Item.new(key: :tasks, label: "Tâches", icon: :tasks, done: tasks.any? && remaining.zero?,
             detail: detail, anchor: "today_card")
  end

  def weight_item
    entry = WeightEntry.find_by(recorded_on: @today)
    Item.new(key: :weight, label: "Poids", icon: :weight, done: entry.present?,
             detail: entry ? "#{ActiveSupport::NumberHelper.number_to_rounded(entry.weight_kg, precision: 1)} kg" : "Pas encore pesé",
             anchor: "today_weight_card")
  end

  def meals_item
    meal = Meal.find_by(recorded_on: @today)
    logged = meal ? Meal::MEALS.count { |m| meal.skipped?(m) || meal.items(m).any? } : 0
    Item.new(key: :meals, label: "Repas", icon: :meals, done: meal.present? && !meal.blank_day?,
             detail: logged.positive? ? "#{logged}/4 renseignés" : "Rien noté",
             anchor: "today_meal_card")
  end

  def workout_item
    workout = Workout.find_by(recorded_on: @today)
    Item.new(key: :workout, label: "Sport", icon: :workout, done: workout&.active? || false,
             detail: workout&.active? ? "Activité notée" : "Pas d'activité",
             anchor: "today_workout_card")
  end
end
