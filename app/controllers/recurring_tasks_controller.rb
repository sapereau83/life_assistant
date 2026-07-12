class RecurringTasksController < ApplicationController
  include TaskBoard

  def create
    rt = RecurringTask.new(recurring_task_params)
    rt.save # invalid (blank title) just re-renders the board unchanged
    render_board
  end

  def destroy
    RecurringTask.find(params[:id]).destroy
    render_board
  end

  private

  def recurring_task_params
    params.require(:recurring_task).permit(:title)
  end
end
