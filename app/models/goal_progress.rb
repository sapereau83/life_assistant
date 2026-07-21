# Plain Ruby object that turns the user's goals into per-goal progress rows for
# the dashboard: a percent bar, an on-track flag and a gentle nudge when behind.
class GoalProgress
  Item = Struct.new(:key, :label, :icon, :detail, :percent, :on_track, :nudge, :path_name, keyword_init: true)

  def initialize(goal: Goal.current, today: Date.current)
    @goal = goal
    @today = today
    @week = @today.beginning_of_week..@today.end_of_week
  end

  def items
    [ weight_item, workouts_item, meals_item, steps_item ].compact
  end

  private

  def weight_item
    target = @goal.effective_target_weight
    latest = WeightEntry.recent_first.first
    if latest.nil?
      return Item.new(key: :weight, label: "Poids cible", icon: :weight,
                      detail: "Cible #{fmt(target)} kg", percent: 0, on_track: false,
                      nudge: "Ajoute une pesée pour suivre cet objectif.", path_name: :weight_entries)
    end

    current   = latest.weight_kg
    start     = WeightEntry.chronological.first.weight_kg
    remaining = (current - target).round(1)
    denom     = (start - target)
    percent   = denom.zero? ? 100 : (((start - current) / denom) * 100).clamp(0, 100).round
    on_track  = remaining.abs <= 0.5

    detail = "#{fmt(current)} → cible #{fmt(target)} kg" +
             (on_track ? " · atteint" : " · reste #{fmt(remaining.abs)} kg")
    nudge = on_track ? nil : (remaining > 0 ? "Encore #{fmt(remaining.abs)} kg à perdre." : "#{fmt(remaining.abs)} kg sous la cible.")

    Item.new(key: :weight, label: "Poids cible", icon: :weight, detail: detail,
             percent: percent, on_track: on_track, nudge: nudge, path_name: :weight_entries)
  end

  def workouts_item
    target = @goal.weekly_workouts.to_i
    return nil if target.zero?

    done     = Workout.where(recorded_on: @week).select(&:active?).size
    percent  = ((done.to_f / target) * 100).clamp(0, 100).round
    on_track = done >= target
    missing  = target - done

    Item.new(key: :workouts, label: "Sport / semaine", icon: :workout,
             detail: "#{done} / #{target} séances cette semaine", percent: percent, on_track: on_track,
             nudge: on_track ? nil : "Encore #{missing} séance#{'s' if missing > 1} d'ici dimanche.",
             path_name: :workouts)
  end

  def meals_item
    return nil unless @goal.log_meals_daily?

    today_meal   = Meal.find_by(recorded_on: @today)
    logged_today = today_meal.present? && !today_meal.blank_day?
    days         = Meal.where(recorded_on: @week).reject(&:blank_day?).size
    elapsed      = (@today - @today.beginning_of_week).to_i + 1
    percent      = ((days.to_f / elapsed) * 100).clamp(0, 100).round

    detail = (logged_today ? "Noté aujourd'hui" : "Pas encore noté") + " · #{days}/#{elapsed} j cette semaine"
    Item.new(key: :meals, label: "Repas quotidiens", icon: :meals, detail: detail,
             percent: percent, on_track: logged_today,
             nudge: logged_today ? nil : "Note tes repas du jour.", path_name: :meals)
  end

  def steps_item
    target = @goal.daily_steps.to_i
    return nil if @goal.daily_steps.blank? || target.zero?

    steps    = Workout.find_by(recorded_on: @today)&.steps.to_i
    percent  = ((steps.to_f / target) * 100).clamp(0, 100).round
    on_track = steps >= target
    missing  = target - steps

    Item.new(key: :steps, label: "Pas / jour", icon: :steps,
             detail: "#{delim(steps)} / #{delim(target)} pas aujourd'hui", percent: percent, on_track: on_track,
             nudge: on_track ? nil : "Encore #{delim(missing)} pas aujourd'hui.", path_name: :workouts)
  end

  def fmt(value)   = ActiveSupport::NumberHelper.number_to_rounded(value, precision: 1)
  def delim(value) = ActiveSupport::NumberHelper.number_to_delimited(value)
end
