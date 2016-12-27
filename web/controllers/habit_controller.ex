defmodule Habits.HabitController do
  use Habits.Web, :controller

  alias Habits.Habit
  alias Habits.Session

  plug :scrub_params, "habit" when action in [:create, :update]

  def index(conn, _params) do
    render conn, "index.html"
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
