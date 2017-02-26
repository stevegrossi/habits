defmodule Achievement.Streak do

  alias Habits.{Repo, Habit}

  @enforce_keys ~w(name threshold value)a
  defstruct ~w(name threshold value)a

  def new(%Habit{} = habit, threshold, name) when is_integer(threshold)
                                              and is_binary(name) do
    %__MODULE__{
      name: name,
      threshold: threshold,
      value: Habit.get_longest_streak(habit)
    }
  end
end
