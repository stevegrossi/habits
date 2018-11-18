defmodule Habits.Achievements.StreakLength do
  @moduledoc false

  use Habits.Achievements.Achievement

  alias Habits.Habits.Habit
  alias Habits.Habits

  defp value_for(%Habit{} = habit) do
    Habits.get_longest_streak(habit)
  end
end
