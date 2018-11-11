defmodule Habits.SessionTest do
  use Habits.DataCase

  alias Habits.Auth.Session

  @valid_attrs %{account_id: "12345", location: "Earth"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Session.changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "generates a token" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.changes.token
  end
end
