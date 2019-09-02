defmodule Habits.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Habits.{Repo, Accounts.Account}
  alias Habits.Date, as: DateHelpers

  def create_account(attrs \\ %{}) do
    if Repo.exists?(Account) do
      {:error, "An account already exists. Please log in."}
    else
      %Account{}
      |> Account.changeset(attrs)
      |> Repo.insert()
    end
  end

  def get_account!(id), do: Repo.get!(Account, id)

  def get_by_email(email) when is_binary(email) do
    Account
    |> Repo.get_by(email: email)
  end

  @doc """
  Returns a list of CheckIns-counts by week, beginning with the first week for
  which there was a CheckIn.

  We ignore the %Account() argument assuming there can be only one,
  but we should probably still specify that.
  """
  def time_series_check_in_data(%Account{} = account, end_date \\ DateHelpers.today()) do
    query = """
    SELECT
      COUNT(check_ins.*)
    FROM generate_series((
      SELECT MIN(date_trunc('week', check_ins.date))
      FROM check_ins
      INNER JOIN habits
        ON habits.id = check_ins.habit_id
      WHERE habits.account_id = $1
    ), '#{end_date}', '1 week'::interval) week
    LEFT OUTER JOIN check_ins
      ON date_trunc('week', check_ins.date) = week
    INNER JOIN habits
      ON habits.id = check_ins.habit_id
    WHERE habits.account_id = $1
    GROUP BY week
    ORDER BY week
    ;
    """

    %Postgrex.Result{rows: rows} = Ecto.Adapters.SQL.query!(Repo, query, [account.id])
    Enum.map(rows, &List.first/1)
  end
end
