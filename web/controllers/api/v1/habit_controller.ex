defmodule Habits.API.V1.HabitController do
  use Habits.Web, :controller

  alias Habits.Session
  alias Habits.CheckIn
  alias Habits.Habit

  def index(conn, %{"date" => date_string}) do
    {:ok, date} = Timex.parse(date_string, "%F", :strftime)
    habits =
      Session.current_account(conn)
      |> assoc(:habits)
      |> Repo.all

    render conn, "index.json", habits: habits, date: date
  end

  def check_in(conn, %{"habit_id" => habit_id, "date" => date_string}) do
    date = date_string_to_date(date_string)

    with account <- Session.current_account(conn),
         {:ok, habit} <- Habit.get_by_account(account, habit_id),
         {:ok, check_in} <- CheckIn.create_for_date(habit, date) do

      render conn, "show.json", habit: habit, date: date_string
    else
      {:error, message} ->
        conn
        |> put_status(404)
        |> render("error.json", error: message)
    end
  end

  def check_out(conn, %{"habit_id" => habit_id, "date" => date_string}) do
    date = date_string_to_date(date_string)

    with account <- Session.current_account(conn),
         {:ok, habit} <- Habit.get_by_account(account, habit_id),
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
