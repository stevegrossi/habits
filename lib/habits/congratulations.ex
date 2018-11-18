defmodule Habits.Congratulations do
  @moduledoc """
  Responsible for determining whether or not to notify the user of having
  reached a milestone for a habit, and issuing that notification.
  """

  alias Habits.Habits.Habit
  alias Habits.{Habits, Notification}

  def for(%Habit{} = habit) do
    check_in_count = Habits.check_in_count(habit)

    if check_in_count > 0 && rem(check_in_count, 50) == 0 do
      Notification.new(habit.name, "Checked in #{check_in_count} times!")
    end

    current_streak = Habits.get_current_streak(habit)

    if current_streak > 0 && rem(current_streak, 25) == 0 do
      Notification.new(habit.name, "#{current_streak} in a row!")
    end
  end
end
