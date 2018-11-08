defmodule HabitsWeb.API.V1.AccountController do
  use Habits.Web, :controller

  alias Habits.{Repo, Accounts}
  alias HabitsWeb.{Session, API.V1.SessionView}

  @doc """
  Return information about the current user’s account
  """
  def show(conn, _params) do
    conn
    |> render("show.json", account: conn.assigns.current_account)
  end

  @doc """
  Register a new account unless one exists.
  """
  def create(conn, %{"account" => account_params}) do
    with {:ok, account} <- Accounts.create_account(account_params),
         {:ok, session} <- create_session(account)
    do
      conn
      |> put_status(:created)
      |> put_view(SessionView)
      |> render("show.json", session: session)
    else
      {:error, message} ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", message: message)
    end
  end

  # @TODO: make Sessions.create_session
  defp create_session(%Accounts.Account{id: account_id}) do
    %Session{}
    |> Session.changeset(%{account_id: account_id, location: "Initial registration"})
    |> Repo.insert
  end
end
