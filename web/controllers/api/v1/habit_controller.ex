defmodule Habits.API.V1.HabitController do
  use Habits.Web, :controller

  alias Habits.{Repo, CheckIn, Habit, Notification}

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
    date = Date.from_iso8601!(date_string)
    habits =
      current_account
      |> assoc(:habits)
      |> order_by(:name)
      |> Repo.all

    render conn, "index.json", habits: habits, date: date
  end

  @doc """
  Return detailed information about a single habit.
  """
  def show(conn, %{"id" => habit_id}, current_account) do
    habit =
      current_account
      |> assoc(:habits)
      |> Repo.get(habit_id)

    render conn, "show.json", habit: habit
  end

  @doc """
  Create a new habit in the account, given a name
  """
  def create(conn, %{"habit" => habit_params}, current_account) do
    habit =
      %Habit{account_id: current_account.id}
      |> Habit.changeset(habit_params)
      |> Repo.insert!

    conn
    |> put_status(:created)
    |> render("habit.json", habit: habit)
  end

  @doc """
  Update the name of a habit in the current account
  """
  def update(conn, %{"id" => habit_id, "name" => name}, current_account) do
    habit =
      current_account
      |> assoc(:habits)
      |> Repo.get(habit_id)
      |> Habit.changeset(%{name: name})
      |> Repo.update!

    conn
    |> put_status(:ok)
    |> render("habit.json", habit: habit)
  end

  @doc """
  Deletes a habit from the current account.
  """
  def delete(conn, %{"id" => habit_id}, current_account) do
    current_account
    |> assoc(:habits)
    |> Repo.get(habit_id)
    |> Repo.delete

    render conn, "success.json"
  end

  @doc """
  Create a CheckIn for the given date and habit, unless one exists.
  """
  def check_in(conn, %{"habit_id" => habit_id, "date" => date_string}, current_account) do
    date = Date.from_iso8601!(date_string)

    Task.start(fn ->
      Process.sleep(1000)
      Notification.new("Checked in!")
    end)

    with {:ok, habit} <- Habit.get_by_account(current_account, habit_id),
         {:ok, _check_in} <- CheckIn.create_for_date(habit, date) do

      render conn, "habit.json", habit: habit, date: date_string
    else
      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: message)
    end
  end

  @doc """
  Delete the CheckIn for the given date and habit.
  """
  def check_out(conn, %{"habit_id" => habit_id, "date" => date_string}, current_account) do
    date = Date.from_iso8601!(date_string)

    Task.start(fn ->
      Process.sleep(1000)
      Notification.new("Checked out!")
    end)

    with {:ok, habit} <- Habit.get_by_account(current_account, habit_id),
         {:ok, check_in} <- CheckIn.get_by_date(habit, date) do

      Repo.delete!(check_in)
      render conn, "habit.json", habit: habit, date: date_string
    else
      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: message)
    end
  end
end
