defmodule Habits.Habits.Habit do
  @moduledoc """
  Data logic for the core Habit domain model, which belongs to an Account and
  has many CheckIns on specific dates.
  """

  use Ecto.Schema

  import Ecto, only: [assoc: 2]
  import Ecto.Changeset
  import Ecto.Query

  alias Habits.Repo
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

  @doc """
  Return whether a CheckIn exists for the given habit and date
  """
  def checked_in?(%__MODULE__{} = habit, date) do
    habit
    |> assoc(:check_ins)
    |> where(date: ^date)
    |> Repo.exists?()
  end

  @doc """
  Returns a list of CheckIns-counts by week, beginning with the first week for
  which there was a CheckIn for the given Habit
  """
  def check_in_data(habit) do
    query = """
    SELECT
      COUNT(check_ins.*)
    FROM generate_series((
      SELECT MIN(date_trunc('week', check_ins.date))
      FROM check_ins
      WHERE check_ins.habit_id = $1
    ), NOW(), '1 week'::interval) week
    LEFT OUTER JOIN check_ins
      ON date_trunc('week', check_ins.date) = week
      AND check_ins.habit_id = $1
    GROUP BY week
    ORDER BY week
    ;
    """

    %Postgrex.Result{rows: rows} = Ecto.Adapters.SQL.query!(Repo, query, [habit.id])
    Enum.map(rows, &List.first/1)
  end
end
