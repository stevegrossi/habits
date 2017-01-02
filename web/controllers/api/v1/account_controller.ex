defmodule Habits.API.V1.AccountController do
  use Habits.Web, :controller

  @doc """
  Return information about the current user’s account
  """
  def show(conn, _params) do
    conn
    |> render("show.json", account: conn.assigns.current_account)
  end
end
