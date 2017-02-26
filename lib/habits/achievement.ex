defmodule Achievement do

  alias Habits.{Account, Habit}

  def all_for(%Account{} = account) do
    [
      Achievement.CheckInCount.new(account, 100),
      Achievement.CheckInCount.new(account, 1000),
      Achievement.CheckInCount.new(account, 10000),
      Achievement.HabitCount.new(account, 5),
      Achievement.HabitCount.new(account, 10)
    ]
  end
  def all_for(%Habit{} = habit) do
    [
      Achievement.CheckInCount.new(habit, 100),
      Achievement.CheckInCount.new(habit, 1000),
      Achievement.Streak.new(habit, 10)
    ]
  end
end
