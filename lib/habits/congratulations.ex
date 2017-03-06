defmodule Habits.Congratulations do
  @moduledoc """
  Responsible for determining whether or not to notify the user of having
  reached a milestone for a habit, and issuing that notification.
  """

  require Ecto.Query
  alias Habits.{Notification, Repo, Habit}

  def for(%Habit{} = habit) do
    check_in_count = Habit.check_in_count(habit)
    if rem(check_in_count, 50) == 0 do
      Notification.new(habit.name, "Checked in #{check_in_count} times!")
    end

    current_streak = Habit.get_current_streak(habit)
    if rem(current_streak, 25) == 0 do
      Notification.new(habit.name, "#{current_streak} in a row!")
    end
  end
end
