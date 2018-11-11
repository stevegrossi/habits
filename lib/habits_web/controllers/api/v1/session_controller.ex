defmodule HabitsWeb.API.V1.SessionController do
  use Habits.Web, :controller

  alias Habits.Auth

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
    case Auth.log_out(token) do
      :ok ->
        conn
        |> render("success.json")

      {:error, :invalid_token} ->
        conn
        |> send_resp(:not_found, "")
        |> halt
    end
  end

  defp get_location(conn) do
    case GeoIP.lookup(conn) do
      {:ok, %GeoIP.Location{} = location} -> location
      _ -> nil
    end
  end
end
