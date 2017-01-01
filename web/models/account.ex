defmodule Habits.Account do
  @moduledoc """
  Data logic for the Account domain model, which represents a user of the app.
  """

  use Habits.Web, :model

  schema "accounts" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :habits, Habits.Habit
    has_many :sessions, Habits.Session

    timestamps
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
    |> validate_required(:encrypted_password)
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
