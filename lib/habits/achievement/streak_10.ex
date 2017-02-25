defmodule Achievement.Streak10 do

  alias Habits.{Repo, Habit}

  @name "10 in a Row"
  @threshold 10

  defstruct name: @name,
            threshold: @threshold,
            value: nil

  def for(%Habit{} = habit) do
    %__MODULE__{value: Habit.get_longest_streak(habit)}
  end
end
