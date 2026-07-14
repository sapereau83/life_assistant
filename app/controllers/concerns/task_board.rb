# Shared loading + turbo rendering of the task "board" (today, bucket, flat
# list and daily recurring tasks), used by TasksController and
# RecurringTasksController so every mutation keeps all views in sync.
module TaskBoard
  extend ActiveSupport::Concern

  private

  def load_board
    RecurringTask.ensure_today!

    @today_tasks = Task.for_day(Date.current).where(state: %i[todo done]).ordered
    @bucket = Task.bucket
    @list_active = Task.where(state: %i[todo to_validate]).order(day: :asc, position: :asc)
    @list_done = Task.done.for_day(Date.current).ordered
    @recurring = RecurringTask.active.order(:position, :created_at)
    # The quick-add form always renders a blank task, except on a failed
    # create where @new_task carries the typed title + errors. It is kept
    # separate from @task (the mutated task) so completing/deleting a task
    # never leaks its title into the add input.
    @new_task ||= Task.new
  end

  def render_board(status: :ok)
    load_board
    respond_to do |format|
      format.turbo_stream { render "tasks/board", status: status }
      format.html { redirect_back fallback_location: root_path }
    end
  end
end
