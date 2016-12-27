defmodule Habits.API.V1.HabitController do
  use Habits.Web, :controller

  alias Habits.Session
  alias Habits.CheckIn

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

    habit =
      Session.current_account(conn)
      |> assoc(:habits)
      |> Habits.Repo.get(habit_id)

    check_ins =
      habit
      |> assoc(:check_ins)
      |> where(date: ^date)

    unless Habits.Repo.exists?(check_ins) do
      Habits.Repo.insert!(%CheckIn{habit_id: String.to_integer(habit_id), date: date})
    end

    render conn, "show.json", habit: habit, date: date_string
  end

  def check_out(conn, %{"habit_id" => habit_id, "date" => date_string}) do
    date = date_string_to_date(date_string)

    habit =
      Session.current_account(conn)
      |> assoc(:habits)
      |> Habits.Repo.get(habit_id)

    check_in =
      habit
      |> assoc(:check_ins)
      |> where(date: ^date)
      |> Habits.Repo.one

    Habits.Repo.delete!(check_in)

    render conn, "show.json", habit: habit, date: date_string
  end

  defp date_string_to_date(date_string) do
    date_string
    |> Timex.parse!("%F", :strftime)
    |> Timex.to_date
  end
end
