defmodule Habits.API.V1.HabitController do
  use Habits.Web, :controller

  alias Habits.Session
  alias Habits.CheckIn

  def index(conn, %{"date" => date_string}) do
    {:ok, date} = Timex.parse(date_string, "%F", :strftime)
    habits = Repo.all(assoc(Session.current_account(conn), :habits))

    render conn, "index.json", habits: habits, date: date
  end

  def check_in(conn, %{"habit_id" => habit_id, "date" => date_string}) do
    date = date_string_to_timex(date_string)

    habit = Habits.Repo.one(
      from g in Habits.Habit,
       where: g.account_id == ^Session.current_account(conn).id,
       where: g.id == ^habit_id,
      select: g
    )

    query = Ecto.Query.from c in Habits.CheckIn,
      where: c.habit_id == ^habit.id,
      where: c.date == ^date

    unless Habits.Repo.exists?(query) do
      Habits.Repo.insert!(%CheckIn{habit_id: String.to_integer(habit_id), date: date})
    end

    render conn, "show.json", habit: habit, date: date_string
  end

  def check_out(conn, %{"habit_id" => habit_id, "date" => date_string}) do
    date = date_string_to_timex(date_string)

    habit = Habits.Repo.one(
      from g in Habits.Habit,
       where: g.account_id == ^Session.current_account(conn).id,
       where: g.id == ^habit_id,
      select: g
    )

    check_in = Habits.Repo.one(
      from c in Habits.CheckIn,
       where: c.habit_id == ^habit.id,
       where: c.date == ^date,
      select: c
    )

    Habits.Repo.delete!(check_in)

    render conn, "show.json", habit: habit, date: date_string
  end

  defp date_string_to_timex(date_string) do
    {:ok, timex} = Timex.parse(date_string, "%F", :strftime)
    timex
  end
end
