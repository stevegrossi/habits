defmodule Habits.HabitTest do
  use Habits.DataCase

  alias HabitsWeb.Habit

  @valid_attrs %{name: "some content", account_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Habit.changeset(%Habit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Habit.changeset(%Habit{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe ".get_current_streak" do

    test "gets the current_streak before checking in today" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))
      Factory.insert(:check_in, habit: habit, date: days_ago(1))

      assert Habit.get_current_streak(habit) == 2
    end

    test "gets the current_streak after checking in today" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))
      Factory.insert(:check_in, habit: habit, date: days_ago(1))
      Factory.insert(:check_in, habit: habit, date: days_ago(0))

      assert Habit.get_current_streak(habit) == 3
    end

    test "breaks the current_streak when your previous check-in was 2 days ago" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))
      Factory.insert(:check_in, habit: habit, date: days_ago(0))

      assert Habit.get_current_streak(habit) == 1
    end

    test "zeroes out the current_streak when you haven't checked in in 2 days" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(2))

      assert Habit.get_current_streak(habit) == 0
    end
  end

  describe ".get_longest_streak" do

    test "returns the longest consecutive streak for a habit" do
      habit = Factory.insert(:habit)
      Factory.insert(:check_in, habit: habit, date: days_ago(7))
      Factory.insert(:check_in, habit: habit, date: days_ago(6))
      Factory.insert(:check_in, habit: habit, date: days_ago(5))
      Factory.insert(:check_in, habit: habit, date: days_ago(3))

      assert Habit.get_longest_streak(habit) == 3
    end
  end

  defp days_ago(days) do
    Habits.Date.today
    |> Habits.Date.shift_days(-days)
  end
end
