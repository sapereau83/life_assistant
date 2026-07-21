class GoalsController < ApplicationController
  def edit
    @goal = Goal.current
  end

  def update
    @goal = Goal.current
    if @goal.update(goal_params)
      redirect_to dashboard_path, notice: "Objectifs mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:target_weight_kg, :weekly_workouts, :daily_steps, :log_meals_daily)
  end
end
