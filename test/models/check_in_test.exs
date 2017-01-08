defmodule Habits.CheckInTest do
  use Habits.ModelCase

  alias Habits.CheckIn

  @valid_attrs %{date: Habits.Date.today, habit_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CheckIn.changeset(%CheckIn{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CheckIn.changeset(%CheckIn{}, @invalid_attrs)
    refute changeset.valid?
  end
end
