defmodule Achievement.Streak do

  use Achievement
  alias Habits.Habit

  def value_for(%Habit{} = habit) do
    Habit.get_longest_streak(habit)
  end
end
