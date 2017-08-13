defmodule HabitsWeb.API.V1.SessionController do
  use Habits.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Habits.Accounts.Account
  alias HabitsWeb.Session

  def index(conn, %{}) do
    current_account = conn.assigns.current_account
    sessions =
      current_account
      |> assoc(:sessions)
      |> order_by(desc: :id)
      |> Repo.all

    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"account" => account_params}) do
    # @TODO: make Accounts.get_by_email!
    account = Repo.get_by(Account, email: account_params["email"])
    cond do
      account && checkpw(account_params["password"], account.encrypted_password) ->
        session_changeset = Session.changeset(%Session{}, %{
          account_id: account.id,
          location: get_location(conn)
        })
        {:ok, session} = Repo.insert(session_changeset)
        conn
        |> put_status(:created)
        |> render("show.json", session: session)
      account ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", account_params)
      true ->
        dummy_checkpw()
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
      {:ok, %GeoIP.Location{city: city, region_name: region, country_name: country}}
        when not city in ["", nil]
        and not region in ["", nil]
        and not country in ["", nil] ->

        city <> ", " <> region <> ", " <> country

      _ ->
        Session.default_location
    end
  end
end
