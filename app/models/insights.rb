# Plain Ruby object that crunches cross-tracker stats for the dashboard.
# Not an ActiveRecord model — just reads from the four trackers.
class Insights
  Scatter = Struct.new(:date, :steps, :delta, keyword_init: true)

  def initialize(today: Date.current)
    @today = today
    @weights  = WeightEntry.chronological.to_a
    @workouts = Workout.chronological.to_a
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
  def logging_streak
    logged = logged_dates
    streak = 0
    day = @today
    while logged.include?(day)
      streak += 1
      day -= 1
    end
    streak
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

  def logged_dates
    @logged_dates ||= (
      WeightEntry.pluck(:recorded_on) +
      Workout.pluck(:recorded_on) +
      Meal.pluck(:recorded_on) +
      Task.where(state: %i[todo done]).pluck(:day)
    ).to_set
  end
end
