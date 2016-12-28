defmodule Habits.AccountController do
  use Habits.Web, :controller

  def show(conn, _params) do
    account = conn.assigns.current_account
    render(conn, "show.html", account: account)
  end
end
