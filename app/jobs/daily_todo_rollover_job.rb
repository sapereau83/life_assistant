class DailyTodoRolloverJob < ApplicationJob
  queue_as :default

  # Runs every night at midnight (see config/recurring.yml).
  # Closes the day: every task still "todo" from a past day is moved into the
  # "à valider" bucket, so it resurfaces the next day you open the app.
  def perform
    rolled = Task.todo.where(day: ...Date.current).update_all(
      state: Task.states[:to_validate],
      rolled_over_at: Time.current,
      updated_at: Time.current
    )

    Rails.logger.info("[DailyTodoRolloverJob] moved #{rolled} unfinished task(s) to the bucket")
    rolled
  end
end
