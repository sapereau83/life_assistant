class WorkoutsController < ApplicationController
  before_action :set_workout, only: %i[update destroy]

  def index
    load_board
  end

  def create
    @workout = Workout.find_or_initialize_by(recorded_on: workout_params[:recorded_on])
    @workout.assign_attributes(workout_params)

    if @workout.save
      @workout = Workout.new(recorded_on: Date.current)
      render_board
    else
      load_board(keep_record: true)
      respond_to do |format|
        format.turbo_stream { render :board, status: :unprocessable_entity }
        format.html { redirect_to workouts_path, alert: @workout.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    @workout.update(workout_params)
    render_board
  end

  def destroy
    @workout.destroy
    render_board
  end

  private

  def set_workout
    @workout = Workout.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:recorded_on, :description, :duration_minutes, :steps)
  end

  def load_board(keep_record: false)
    @workouts = Workout.recent_first
    @workout = Workout.new(recorded_on: Date.current) unless keep_record
  end

  def render_board
    load_board
    respond_to do |format|
      format.turbo_stream { render :board }
      format.html { redirect_to workouts_path }
    end
  end
end
