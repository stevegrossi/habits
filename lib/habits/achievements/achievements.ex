defmodule Habits.Achievements do
  @moduledoc """
  The Achievements context.
  """

  alias HabitsWeb.{Habit}
  alias Habits.{Accounts.Account}
  alias Habits.Achievements.{CheckInCount, HabitCount, StreakLength}

  @doc """
  Specifies which achievements apply in each context
  (e.g. account-level vs. habit-level) as well as their order
  """
  def all_for(%Account{} = account) do
    [
      CheckInCount.new(account, 100, "Check In 100 Times"),
      CheckInCount.new(account, 1_000, "Check In 1,000 Times"),
      CheckInCount.new(account, 10_000, "Check In 10,000 Times"),
      HabitCount.new(account, 5, "Track 5 Habits"),
      HabitCount.new(account, 10, "Track 10 Habits")
    ]
  end
  def all_for(%Habit{} = habit) do
    [
      CheckInCount.new(habit, 100, "Check In 100 Times"),
      CheckInCount.new(habit, 1_000, "Check In 1,000 Times"),
      StreakLength.new(habit, 7, "Week-long Streak"),
      StreakLength.new(habit, 30, "Month-long Streak"),
      StreakLength.new(habit, 365, "Year-long Streak!")
    ]
  end
end
