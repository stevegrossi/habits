defmodule Habits.AccountTest do
  use Habits.ModelCase

  alias HabitsWeb.Account

  @valid_attrs %{
    email: "foo@bar.baz",
    password: "p4ssw0rd"
  }
  @invalid_attrs %{email: "foo"}

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

  test "encrypts the password when changing it" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
    assert changeset.changes.encrypted_password
  end
end
