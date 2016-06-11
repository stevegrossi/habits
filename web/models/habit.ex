defmodule Habits.Habit do
  use Habits.Web, :model

  schema "habits" do
    field :name, :string
    belongs_to :account, Habits.Account

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :account_id])
    |> validate_required([:name, :account_id])
  end

  @doc """
  Calculates a habit’s current streak and updates its record.

  The current streak is the number of consecutive daily check-ins
  for a habit up until yesterday, or today if you've checked in today.

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

    {:ok, query} = Ecto.Adapters.SQL.query(Habits.Repo, sql, [habit.id])
    [[rows]] = query.rows
    rows
  end
end
