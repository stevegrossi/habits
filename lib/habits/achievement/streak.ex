defmodule Achievement.Streak do

  use Achievement
  alias Habits.{Repo, Habit}

  def new(%Habit{} = habit, threshold, name) when is_integer(threshold)
                                              and is_binary(name) do
    %__MODULE__{
      name: name,
      threshold: threshold,
      value: Habit.get_longest_streak(habit)
    }
  end
end
