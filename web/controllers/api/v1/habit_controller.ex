defmodule Habits.API.V1.HabitController do
  use Habits.Web, :controller

  alias Habits.CheckIn
  alias Habits.Habit

  @doc """
  Override action/2 to provide current_account to actions
  """
  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_account]]
    apply(__MODULE__, action_name(conn), args)
  end

  @doc """
  Return all of the current account’s habits for the given date as JSON
  """
  def index(conn, %{"date" => date_string}, current_account) do
    date = date_string_to_date(date_string)
    habits =
      current_account
      |> assoc(:habits)
      |> Repo.all

    render conn, "index.json", habits: habits, date: date
  end

  @doc """
  Create a CheckIn for the given date and habit, unless one exists.
  """
  def check_in(conn, %{"habit_id" => habit_id, "date" => date_string}, current_account) do
    date = date_string_to_date(date_string)

    with {:ok, habit} <- Habit.get_by_account(current_account, habit_id),
         {:ok, _check_in} <- CheckIn.create_for_date(habit, date) do

      render conn, "show.json", habit: habit, date: date_string
    else
      {:error, message} ->
        conn
        |> put_status(404)
        |> render("error.json", error: message)
    end
  end

  @doc """
  Delete the CheckIn for the given date and habit.
  """
  def check_out(conn, %{"habit_id" => habit_id, "date" => date_string}, current_account) do
    date = date_string_to_date(date_string)

    with {:ok, habit} <- Habit.get_by_account(current_account, habit_id),
         {:ok, check_in} <- CheckIn.get_by_date(habit, date) do

      Habits.Repo.delete!(check_in)
      render conn, "show.json", habit: habit, date: date_string
    else
      {:error, message} ->
        conn
        |> put_status(404)
        |> render("error.json", error: message)
    end
  end

  defp date_string_to_date(date_string) do
    date_string
    |> Timex.parse!("%F", :strftime)
    |> Timex.to_date
  end
end