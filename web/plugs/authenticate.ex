defmodule Habits.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Habits.Repo
  alias Habits.Account

  def init(opts), do: opts

  def call(conn, _opts) do
    if account = get_account(conn) do
      conn |> assign(:current_account, account)
    else
      conn
      |> put_flash(:info, "Please log in first.")
      |> redirect(to: "/")
      |> halt
    end
  end

  defp get_account(conn) do
    case conn.assigns[:current_account] do
      nil  -> fetch_account(conn)
      account -> account
    end
  end

  defp fetch_account(conn) do
    find_account(get_session(conn, :current_account))
  end

  defp find_account(nil), do: nil
  defp find_account(id) do
    Repo.get(Account, id)
  end
end
