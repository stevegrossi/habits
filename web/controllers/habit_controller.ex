defmodule Habits.HabitController do
  use Habits.Web, :controller

  alias Habits.Habit
  alias Habits.Session

  plug Habits.Plugs.Authenticate
  plug :scrub_params, "habit" when action in [:create, :update]

  def index(conn, %{"year" => year, "month" => month, "day" => day}) do
    date = {
      String.to_integer(year),
      String.to_integer(month),
      String.to_integer(day)
    }

    habits = Repo.all from g in Habit,
      where: g.account_id == ^Session.current_account(conn).id,
      order_by: [asc: g.name]

    render conn, "index.html",
      habits: habits,
      date: date
  end

  def index(conn, _params) do
    %{year: year, month: month, day: day} = Timex.DateTime.local
    habits = Repo.all(assoc(Session.current_account(conn), :habits))

    render conn, "index.html",
      habits: habits,
      date: {year, month, day}
  end

  def new(conn, _params) do
    changeset = Habit.changeset(%Habit{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"habit" => habit_params}) do
    habit_attributes = Map.merge(habit_params, %{
      "account_id" => Session.current_account(conn).id,
      "current_streak" => 0
    })
    changeset = Habit.changeset(%Habit{}, habit_attributes)

    if changeset.valid? do
      Repo.insert!(changeset)

      conn
      |> put_flash(:info, "Habit created successfully.")
      |> redirect(to: habit_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    habit = Repo.get!(Habit, id)
    render(conn, "show.html", habit: habit)
  end

  def edit(conn, %{"id" => id}) do
    habit = Repo.get!(Habit, id)
    changeset = Habit.changeset(habit)
    render(conn, "edit.html", habit: habit, changeset: changeset)
  end

  def update(conn, %{"id" => id, "habit" => habit_params}) do
    habit = Repo.get!(Habit, id)
    changeset = Habit.changeset(habit, habit_params)

    if changeset.valid? do
      Repo.update!(changeset)

      conn
      |> put_flash(:info, "Habit updated successfully.")
      |> redirect(to: habit_path(conn, :index))
    else
      render(conn, "edit.html", habit: habit, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    habit = Repo.get!(Habit, id)
    Repo.delete!(habit)

    conn
    |> put_flash(:info, "Habit deleted successfully.")
    |> redirect(to: habit_path(conn, :index))
  end
end
