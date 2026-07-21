# Plain Ruby object that crunches cross-tracker stats for the dashboard.
# Not an ActiveRecord model — just reads from the four trackers.
class Insights
  Scatter = Struct.new(:date, :steps, :delta, keyword_init: true)

  def initialize(today: Date.current)
    @today = today
    @weights  = WeightEntry.chronological.to_a
    @workouts = Workout.chronological.to_a
    @meals    = Meal.order(:recorded_on).to_a
  end

  # ---- Weight ----
  def current_weight = @weights.last&.weight_kg
  def start_weight   = @weights.first&.weight_kg

  def total_weight_change
    return nil unless current_weight && start_weight
    current_weight - start_weight
  end

  # ---- Steps ----
  def step_series = @workouts.map { |w| w.steps.to_i }.select(&:positive?)

  def avg_steps
    s = step_series
    s.any? ? (s.sum / s.size) : nil
  end

  def best_steps = step_series.max

  def active_days = @workouts.count(&:active?)

  # ---- Correlation: daily steps vs. day-over-day weight change ----
  # Negative r means "more steps → weight tends to go down".
  def scatter
    by_date = @weights.index_by(&:recorded_on)
    @workouts.filter_map do |w|
      steps = w.steps.to_i
      weight = by_date[w.recorded_on]
      next if steps.zero? || weight.nil?
      d = weight.delta
      next if d.nil?
      Scatter.new(date: w.recorded_on, steps: steps, delta: d.to_f)
    end
  end

  def steps_weight_correlation
    points = scatter
    self.class.pearson(points.map(&:steps), points.map(&:delta))
  end

  # Human-readable takeaway for the correlation.
  def correlation_insight
    r = steps_weight_correlation
    return nil if r.nil?

    strength =
      case r.abs
      when 0...0.2 then "quasi nulle"
      when 0.2...0.4 then "faible"
      when 0.4...0.6 then "modérée"
      else "forte"
      end

    direction =
      if r <= -0.2
        "Plus tu marches, plus ton poids tend à baisser"
      elsif r >= 0.2
        "Curieusement, plus de pas coïncide avec un poids en hausse"
      else
        "Aucun lien net entre tes pas et ton poids"
      end

    { r: r, strength: strength, direction: direction, sample: scatter.size }
  end

  # ---- Logging streak (consecutive days up to today with any tracker entry) ----
  def logging_streak = current_streak(logged_dates)

  # Longest run of consecutive logged days ever (the "record" to beat).
  def best_logging_streak = longest_run(logged_dates)

  # ---- Per-tracker regularity ----
  # Each entry: current streak (consecutive days ending today) + days logged
  # this calendar week, so the dashboard can show one tile per tracker.
  def streaks
    [
      { key: :weight,  label: "Poids",  icon: "⚖️", current: current_streak(weight_dates),  week: week_count(weight_dates) },
      { key: :meals,   label: "Repas",  icon: "🍽️", current: current_streak(meal_dates),    week: week_count(meal_dates) },
      { key: :workout, label: "Sport",  icon: "🏃", current: current_streak(workout_dates), week: week_count(workout_dates) },
      { key: :tasks,   label: "Tâches", icon: "✓",  current: current_streak(task_dates),    week: week_count(task_dates) }
    ]
  end

  def self.pearson(xs, ys)
    n = xs.size
    return nil if n < 3

    sx = xs.sum.to_f
    sy = ys.sum.to_f
    sxx = xs.sum { |x| x * x }.to_f
    syy = ys.sum { |y| y * y }.to_f
    sxy = xs.zip(ys).sum { |x, y| x * y }.to_f

    denom = Math.sqrt((n * sxx - sx**2) * (n * syy - sy**2))
    return nil if denom.zero?

    ((n * sxy - sx * sy) / denom).round(3)
  end

  private

  # Consecutive days ending at today. A day not yet logged today doesn't break
  # the streak (the day isn't over) — we then count back from yesterday.
  def current_streak(dates)
    set = dates.to_set
    day = set.include?(@today) ? @today : @today - 1
    streak = 0
    while set.include?(day)
      streak += 1
      day -= 1
    end
    streak
  end

  # Longest run of consecutive days anywhere in the set.
  def longest_run(dates)
    set = dates.to_set
    best = 0
    set.each do |d|
      next if set.include?(d - 1) # only measure from the start of a run
      len = 1
      len += 1 while set.include?(d + len)
      best = len if len > best
    end
    best
  end

  # Distinct days logged in the current calendar week (Mon–Sun).
  def week_count(dates)
    range = @today.beginning_of_week..@today.end_of_week
    dates.to_set.count { |d| range.cover?(d) }
  end

  def weight_dates  = @weight_dates  ||= @weights.map(&:recorded_on).to_set
  def workout_dates = @workout_dates ||= @workouts.select(&:active?).map(&:recorded_on).to_set
  def meal_dates    = @meal_dates    ||= @meals.reject(&:blank_day?).map(&:recorded_on).to_set
  def task_dates    = @task_dates    ||= Task.where(state: %i[todo done]).distinct.pluck(:day).to_set

  def logged_dates
    @logged_dates ||= (weight_dates + workout_dates + meal_dates + task_dates).to_set
  end
end
