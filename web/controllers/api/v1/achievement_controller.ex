defmodule Habits.API.V1.AchievementController do
  use Habits.Web, :controller

  @doc """
  Override action/2 to provide current_account to actions
  """
  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_account]]
    apply(__MODULE__, action_name(conn), args)
  end

  @doc """
  Return all of the achievements for a habit or account
  """
  def index(conn, %{"habit_id" => habit_id}, current_account) do
    habit =
      current_account
      |> assoc(:habits)
      |> Repo.get(habit_id)

    conn
    |> render("index.json", achievements: Achievement.all_for(habit))
  end
  def index(conn, _params, current_account) do
    conn
    |> render("index.json", achievements: Achievement.all_for(current_account))
  end
end
