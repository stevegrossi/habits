defmodule Habits.API.V1.AchievementController do
  use Habits.Web, :controller

  @doc """
  Return all of the resource’s achievements
  """
  def index(conn, _params) do
    achievements = Achievement.all_for(conn.assigns.current_account)

    conn
    |> render("index.json", achievements: achievements)
  end
end
