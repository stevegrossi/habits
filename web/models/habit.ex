defmodule Habits.Habit do
  @moduledoc """
  Data logic for the core Habit domain model, which belongs to an Account and
  has many CheckIns on specific dates.
  """

  use Habits.Web, :model

  alias Habits.Account
  alias Habits.CheckIn
  alias Habits.Repo

  schema "habits" do
    field :name, :string
    belongs_to :account, Account
    has_many :check_ins, CheckIn

    timestamps
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

  Hat tip: stackoverflow.com/q/22142028/
  """
  def get_current_streak(habit) do
    sql = "
      SELECT COUNT(check_ins.date)
      FROM check_ins
      WHERE check_ins.habit_id = $1
      AND check_ins.date > (
        SELECT calendar.day
        FROM generate_series('2010-01-01'::date, (CURRENT_DATE - INTERVAL '1 day'), '1 day') calendar(day)
        LEFT OUTER JOIN check_ins
          ON check_ins.date = calendar.day
          AND check_ins.habit_id = $1
        WHERE check_ins.date IS NULL
        ORDER BY calendar.day DESC
        LIMIT 1
      );
    "

    {:ok, query} = Ecto.Adapters.SQL.query(Repo, sql, [habit.id])
    [[rows]] = query.rows
    rows
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
end
