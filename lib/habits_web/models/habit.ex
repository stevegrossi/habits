defmodule HabitsWeb.Habit do
  @moduledoc """
  Data logic for the core Habit domain model, which belongs to an Account and
  has many CheckIns on specific dates.
  """

  use Habits.Web, :model

  alias Habits.{Repo, Accounts.Account}
  alias HabitsWeb.{CheckIn, Streak}

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

  def check_in_count(%__MODULE__{} = habit) do
    habit
    |> assoc(:check_ins)
    |> Repo.count()
  end

  @doc """
  The current streak is the number of consecutive daily check-ins
  for a habit up until yesterday, or today if you’ve checked in today.
  """
  def get_current_streak(habit) do
    habit
    |> assoc(:streaks)
    |> Streak.current()
  end

  @doc """
  Returns the longest streak of consecutive daily check-ins for a habit
  """
  def get_longest_streak(habit) do
    habit
    |> assoc(:streaks)
    |> Streak.longest()
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
