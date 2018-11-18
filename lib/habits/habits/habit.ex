defmodule Habits.Habits.Habit do
  @moduledoc """
  Data logic for the core Habit domain model, which belongs to an Account and
  has many CheckIns on specific dates.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Habits.Accounts.Account
  alias Habits.Habits.{CheckIn, Streak}

  schema "habits" do
    field(:name, :string)
    belongs_to(:account, Account)
    has_many(:check_ins, CheckIn)
    has_many(:streaks, Streak)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `habit` struct and `params`.
  """
  def changeset(habit, params \\ %{}) do
    habit
    |> cast(params, [:name, :account_id])
    |> validate_required([:name, :account_id])
  end
end
