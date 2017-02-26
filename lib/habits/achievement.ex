defmodule Achievement do
  @moduledoc false

  alias Habits.{Account, Habit}
  alias Achievement.{CheckInCount, HabitCount, StreakLength}

  @doc """
  Specifies which achievements apply in each context
  (e.g. account-level vs. habit-level) as well as their order
  """
  def all_for(%Account{} = account) do
    [
      CheckInCount.new(account, 100, "Check In 100 times"),
      CheckInCount.new(account, 1_000, "Check In 1,000 times"),
      CheckInCount.new(account, 10_000, "Check In 10,000 times"),
      HabitCount.new(account, 5, "Track 5 Habits"),
      HabitCount.new(account, 10, "Track 10 Habits")
    ]
  end
  def all_for(%Habit{} = habit) do
    [
      CheckInCount.new(habit, 100, "Check In 100 times"),
      CheckInCount.new(habit, 1_000, "Check In 1,000 times"),
      StreakLength.new(habit, 7, "Week-long Streak"),
      StreakLength.new(habit, 30, "Month-long Streak"),
      StreakLength.new(habit, 365, "Year-long Streak!")
    ]
  end

  @doc """
  Shared behavior for individual Achievement modules which `use Achievement`
  """
  defmacro __using__(_) do
    quote do
      @enforce_keys ~w(name threshold value)a
      defstruct ~w(name threshold value)a

      def new(subject, threshold, name) do
        %__MODULE__{
          name: name,
          threshold: threshold,
          value: value_for(subject)
        }
      end
    end
  end
end
