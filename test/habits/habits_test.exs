defmodule Habits.HabitsTest do
  use Habits.DataCase

  alias Habits.Date, as: DateHelpers
  alias Habits.Habits

  describe ".get_current_streak" do
    test "gets the current_streak before checking in today" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))
      Factory.insert(:check_in, habit: habit, date: days_ago(1))

      assert Habits.get_current_streak(habit) == 2
    end

    test "gets the current_streak after checking in today" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))
      Factory.insert(:check_in, habit: habit, date: days_ago(1))
      Factory.insert(:check_in, habit: habit, date: days_ago(0))

      assert Habits.get_current_streak(habit) == 3
    end

    test "breaks the current_streak when your previous check-in was 2 days ago" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))
      Factory.insert(:check_in, habit: habit, date: days_ago(0))

      assert Habits.get_current_streak(habit) == 1
    end

    test "zeroes out the current_streak when you haven't checked in in 2 days" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))

      assert Habits.get_current_streak(habit) == 0
    end
  end

  defp days_ago(days) do
    DateHelpers.today()
    |> DateHelpers.shift_days(-days)
  end
end
