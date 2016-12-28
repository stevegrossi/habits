defmodule Habits.Plugs.Authenticate do
  @moduledoc """
  Finds the current Account in the database if its ID is stored in the session,
  otherwise redirects to the home page and requires the user to log in first.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Habits.Repo
  alias Habits.Account

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_account: %Account{}}} = conn, _opts) do
    conn
  end
  def call(conn, _opts) do
    if account = find_account_from_session(conn) do
      conn
      |> assign(:current_account, account)
    else
      conn
      |> put_flash(:info, "Please log in first.")
      |> redirect(to: "/")
      |> halt()
    end
  end

  defp find_account_from_session(conn) do
    conn
    |> get_session(:current_account)
    |> find_account()
  end

  defp find_account(nil), do: nil
  defp find_account(id) do
    Repo.get(Account, id)
  end
end
