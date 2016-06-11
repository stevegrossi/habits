defmodule Habits.AccountTest do
  use Habits.ModelCase

  alias Habits.Account

  @valid_attrs %{
    email: "foo@bar.baz",
    encrypted_password: "P4SSW0RD"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email must be valid" do
    attrs = %{@valid_attrs | email: "nope"}
    changeset = Account.changeset(%Account{}, attrs)
    refute changeset.valid?
  end
end
