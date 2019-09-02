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

  describe ".get_longest_streak" do
    test "returns the longest consecutive streak for a habit" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(7))
      Factory.insert(:check_in, habit: habit, date: days_ago(6))
      Factory.insert(:check_in, habit: habit, date: days_ago(5))
      Factory.insert(:check_in, habit: habit, date: days_ago(3))

      assert Habits.get_longest_streak(habit) == 3
    end
  end

  describe ".checked_in_on?" do
    test "returns the longest consecutive streak for a habit" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(1))

      refute Habits.checked_in_on?(habit, days_ago(0))
      assert Habits.checked_in_on?(habit, days_ago(1))
      refute Habits.checked_in_on?(habit, days_ago(2))
    end
  end

  describe ".time_series_check_in_data" do
    test "returns weekly check-in counts" do
      habit = Factory.insert(:habit)
      sunday = ~D[2018-11-11]
      monday = ~D[2018-11-12]
      tuesday = ~D[2018-11-13]
      thursday = ~D[2018-11-15]
      end_date = ~D[2018-11-18]
      Factory.insert(:check_in, habit: habit, date: sunday)
      Factory.insert(:check_in, habit: habit, date: monday)
      Factory.insert(:check_in, habit: habit, date: tuesday)
      Factory.insert(:check_in, habit: habit, date: thursday)

      # Check-ins from other habits should be ignored
      other_habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: other_habit, date: thursday)

      result = Habits.time_series_check_in_data(habit, end_date)
      assert result == [1, 3]
    end
  end

  defp days_ago(days) do
    DateHelpers.today()
    |> DateHelpers.shift_days(-days)
  end
end
