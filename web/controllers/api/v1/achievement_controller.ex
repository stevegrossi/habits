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
  Return all of the resource’s achievements
  """
  def index(conn, params, current_account) do
    achievements =
      if params["habit_id"] do
        habit =
          current_account
          |> assoc(:habits)
          |> Repo.get(params["habit_id"])

        Achievement.all_for(habit)
      else
        Achievement.all_for(current_account)
      end

    conn
    |> render("index.json", achievements: achievements)
  end
end
