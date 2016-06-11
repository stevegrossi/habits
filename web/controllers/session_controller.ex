defmodule Habits.SessionController do
  use Habits.Web, :controller

  alias Habits.Session

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Habits.Repo) do
      {:ok, account} ->
        conn
        |> put_session(:current_account, account.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: Habits.Router.Helpers.habit_path(Habits.Endpoint, :index))
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_account)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
