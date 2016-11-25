defmodule Habits.Account do
  use Habits.Web, :model

  schema "accounts" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :habits, Habits.Habit

    timestamps
  end

  @doc """
  Builds a changeset based on the `account` struct and `params`.
  """
  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:email, :encrypted_password])
    |> validate_required(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:email)
  end
end
