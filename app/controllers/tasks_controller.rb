class TasksController < ApplicationController
  include TaskBoard

  before_action :set_task, only: %i[update destroy complete reopen move_to_today toggle_recurring]

  # "Aujourd'hui" board: today's list + the "à valider" bucket.
  def index
    load_board
  end

  # Simple flat checklist of everything still to do (todo + bucket).
  def list
    load_board
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      @task = Task.new # reset the add form
      render_board
    else
      # keep the typed title so the user can fix it
      render_board(status: :unprocessable_entity)
    end
  end

  def update
    @task.update(task_params)
    render_board
  end

  def complete
    @task.complete!
    render_board
  end

  def reopen
    @task.reopen!
    render_board
  end

  def move_to_today
    @task.move_to_today!
    render_board
  end

  # Turn a one-off task into a daily recurring one (or stop it recurring).
  def toggle_recurring
    if @task.recurring_task
      @task.recurring_task.destroy # nullifies recurring_task_id on its tasks
    else
      rt = RecurringTask.create!(title: @task.title, last_added_on: Date.current)
      @task.update!(recurring_task: rt)
    end
    render_board
  end

  def destroy
    @task.destroy
    render_board
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
