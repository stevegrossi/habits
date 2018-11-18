defmodule Habits.HabitTest do
  use Habits.DataCase

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
end
