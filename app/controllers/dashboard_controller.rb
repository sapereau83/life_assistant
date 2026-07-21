class DashboardController < ApplicationController
  def index
    @insights = Insights.new
    @summary  = DailySummary.new
    @goals    = GoalProgress.new

    # Today snapshot across the four trackers
    @tasks_today   = Task.for_day(Date.current).where(state: %i[todo done]).ordered
    @tasks_done    = @tasks_today.count(&:done?)
    @bucket_count  = Task.to_validate.count
    @weight_latest = WeightEntry.recent_first.first
    @workout_today = Workout.find_by(recorded_on: Date.current)
    @meal_today    = Meal.find_by(recorded_on: Date.current)

    # Series for the mini charts
    @weight_series = WeightEntry.chronological.last(30)
    @steps_series  = Workout.chronological.last(14)
  end
end
