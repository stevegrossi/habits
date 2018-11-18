defmodule Habits.HabitTest do
  use Habits.DataCase

  alias Habits.Date, as: DateHelpers
  alias Habits.Habits.Habit

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
    DateHelpers.today()
    |> DateHelpers.shift_days(-days)
  end
end
