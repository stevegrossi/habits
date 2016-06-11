defmodule Habits.CheckInController do
  use Habits.Web, :controller

  alias Habits.Session
  alias Habits.CheckIn

  plug Habits.Plugs.Authenticate

  def create(conn, %{"habit_id" => habit_id, "date" => date_string}) do
    date = date_string_to_timex(date_string)

    habit = Habits.Repo.one(
      from g in Habits.Habit,
       where: g.account_id == ^Session.current_account(conn).id,
       where: g.id == ^habit_id,
      select: g
    )

    flash = case find_or_create_check_in!(habit.id, date) do
      :already_exists -> "You’ve already checked in to #{habit.name}!"
      :created -> "You checked in to #{habit.name}!"
    end

    redirect = if date do
      %{year: year, month: month, day: day} = date
      habit_path(conn, :index, year, month, day)
    else
      habit_path(conn, :index)
    end

    conn
      |> put_flash(:info, flash)
      |> redirect(to: redirect)
  end

  def delete(conn, %{"habit_id" => habit_id, "id" => check_in_id, "date" => date_string}) do
    date = date_string_to_timex(date_string)
    habit = Habits.Repo.one(
      from g in Habits.Habit,
       where: g.account_id == ^Session.current_account(conn).id,
       where: g.id == ^habit_id,
      select: g
    )

    check_in = Habits.Repo.one(
      from c in Habits.CheckIn,
       where: c.id == ^check_in_id,
       where: c.habit_id == ^habit.id,
       where: c.date == ^date,
      select: c
    )

    Habits.Repo.delete!(check_in)

    redirect = if date do
      %{year: year, month: month, day: day} = date
      habit_path(conn, :index, year, month, day)
    else
      habit_path(conn, :index)
    end

    conn
      |> put_flash(:info, "Removed check-in for #{habit.name}")
      |> redirect(to: redirect)
  end

  defp date_string_to_timex(date_string) do
    {:ok, timex} = Timex.parse(date_string, "%F", :strftime)
    timex
  end

  defp find_or_create_check_in!(habit_id, date) do
    query = Ecto.Query.from c in Habits.CheckIn,
      where: c.habit_id == ^habit_id,
      where: c.date == ^date

    if Habits.Repo.exists?(query) do
      :already_exists
    else
      Habits.Repo.insert!(%CheckIn{habit_id: habit_id, date: date})
      :created
    end
  end
end
