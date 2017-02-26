defmodule Achievement do

  alias Habits.{Account, Habit}

  @doc """
  Specifies which achievements apply in each context
  (e.g. account-level vs. habit-level) as well as their order
  """
  def all_for(%Account{} = account) do
    [
      Achievement.CheckInCount.new(account, 100, "Check In 100 times"),
      Achievement.CheckInCount.new(account, 1000, "Check In 1,000 times"),
      Achievement.CheckInCount.new(account, 10000, "Check In 10,000 times"),
      Achievement.HabitCount.new(account, 5, "Track 5 Habits"),
      Achievement.HabitCount.new(account, 10, "Track 10 Habits")
    ]
  end
  def all_for(%Habit{} = habit) do
    [
      Achievement.CheckInCount.new(habit, 100, "Check In 100 times"),
      Achievement.CheckInCount.new(habit, 1000, "Check In 1,000 times"),
      Achievement.Streak.new(habit, 7, "Week-long Streak"),
      Achievement.Streak.new(habit, 30, "Month-long Streak"),
      Achievement.Streak.new(habit, 365, "Year-long Streak!")
    ]
  end

  @doc """
  Shared behavior for individual Achievement modules which `use Achievement`
  """
  defmacro __using__(_) do
    quote do
      @enforce_keys ~w(name threshold value)a
      defstruct ~w(name threshold value)a
    end
  end
end
