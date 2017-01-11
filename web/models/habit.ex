defmodule Habits.Habit do
  @moduledoc """
  Data logic for the core Habit domain model, which belongs to an Account and
  has many CheckIns on specific dates.
  """

  use Habits.Web, :model

  alias Habits.{Account, CheckIn, Repo, Streak}

  schema "habits" do
    field :name, :string
    belongs_to :account, Account
    has_many :check_ins, CheckIn
    has_many :streaks, Streak

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

  @doc """
  The current streak is the number of consecutive daily check-ins
  for a habit up until yesterday, or today if you’ve checked in today.
  """
  def get_current_streak(habit) do
    habit
    |> assoc(:streaks)
    |> where([s], s.end >= ^Habits.Date.yesterday)
    |> select([s], s.length)
    |> Repo.one || 0
  end

  @doc """
  Gets a habit for a given account.
  """
  def get_by_account(%Account{} = account, habit_id) do
    habit =
      account
      |> assoc(:habits)
      |> Repo.get(habit_id)

    if habit do
      {:ok, habit}
    else
      {:error, "Habit not found"}
    end
  end

  @doc """
  Return the total number of CheckIns for a given habit
  """
  def check_in_count(habit) do
    habit
    |> assoc(:check_ins)
    |> Repo.count
  end
end
