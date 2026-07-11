class MealsController < ApplicationController
  before_action :set_meal, only: %i[update destroy]

  def index
    load_board
  end

  def create
    # One row per day: logging "today" again edits it instead of failing.
    @meal = Meal.find_or_initialize_by(recorded_on: meal_params[:recorded_on])
    @meal.assign_attributes(meal_params)

    if @meal.save
      @meal = Meal.new(recorded_on: Date.current)
      render_board
    else
      load_board(keep_record: true)
      respond_to do |format|
        format.turbo_stream { render :board, status: :unprocessable_entity }
        format.html { redirect_to meals_path, alert: @meal.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    @meal.update(meal_params)
    render_board
  end

  def destroy
    @meal.destroy
    render_board
  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end

  def meal_params
    params.require(:meal).permit(:recorded_on, :breakfast, :lunch, :dinner, :snacks)
  end

  def load_board(keep_record: false)
    @meals = Meal.recent_first
    @meal = Meal.new(recorded_on: Date.current) unless keep_record
  end

  def render_board
    load_board
    respond_to do |format|
      format.turbo_stream { render :board }
      format.html { redirect_to meals_path }
    end
  end
end
