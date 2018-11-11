defmodule HabitsWeb.API.V1.SessionController do
  use Habits.Web, :controller

  alias Habits.{Accounts, Auth}
  alias HabitsWeb.Session

  def index(conn, %{}) do
    sessions = Auth.list_sessions(conn.assigns.current_account)

    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"account" => %{"email" => email, "password" => password} = account_params}) do
    case Auth.log_in(email, password, get_location(conn)) do
      {:ok, session} ->
        conn
        |> put_status(:created)
        |> render("show.json", session: session)
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", account_params)
    end
  end

  def delete(conn, %{"token" => token}) do
    current_account = conn.assigns.current_account

    session =
      current_account
      |> assoc(:sessions)
      |> Repo.get_by(token: token)

    if is_nil(session) do
      conn
      |> send_resp(:not_found, "")
      |> halt
    else
      {:ok, _} = Repo.delete(session)

      conn
      |> render("success.json")
    end
  end

  defp get_location(conn) do
    case GeoIP.lookup(conn) do
      {:ok, %GeoIP.Location{} = location} -> location
      _ -> nil
    end
  end
end
