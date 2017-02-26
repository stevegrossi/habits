defmodule Achievement.Streak do

  alias Habits.{Repo, Habit}

  @enforce_keys ~w(name threshold value)a
  defstruct ~w(name threshold value)a

  def new(%Habit{} = habit, threshold) when is_integer(threshold) do
    %__MODULE__{
      name: "#{threshold} in a Row",
      threshold: threshold,
      value: Habit.get_longest_streak(habit)
    }
  end
end
