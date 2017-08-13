defmodule Habits.Accounts.Account do
  @moduledoc """
  Data logic for the Account schema, which represents a user of the app.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias HabitsWeb.{Habit, Session}

  schema "accounts" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :habits, Habit
    has_many :sessions, Session

    timestamps()
  end

  @doc """
  Builds a changeset based on the `account` struct and `params`.
  """
  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> encrypt_password_if_possible
    |> unique_constraint(:email)
  end

  defp encrypt_password_if_possible(
    %Ecto.Changeset{changes: %{password: password}} = changeset) do

    changeset
    |> put_change(:encrypted_password, hashed_password(password))
  end
  defp encrypt_password_if_possible(%Ecto.Changeset{} = changeset) do
    changeset
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
