class TasksController < ApplicationController
  before_action :set_task, only: %i[update destroy complete reopen move_to_today]

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
      load_board
      respond_to do |format|
        format.turbo_stream { render :board, status: :unprocessable_entity }
        format.html { redirect_back fallback_location: root_path, alert: @task.errors.full_messages.to_sentence }
      end
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

  def load_board
    @today_tasks = Task.for_day(Date.current).where(state: %i[todo done]).ordered
    @bucket = Task.bucket
    # Flat "Mes tâches" list: everything still open, plus today's done items.
    @list_active = Task.where(state: %i[todo to_validate]).order(day: :asc, position: :asc)
    @list_done = Task.done.for_day(Date.current).ordered
    @task ||= Task.new
  end

  def render_board
    load_board
    respond_to do |format|
      format.turbo_stream { render :board }
      format.html { redirect_back fallback_location: root_path }
    end
  end
end
