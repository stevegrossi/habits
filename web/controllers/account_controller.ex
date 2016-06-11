defmodule Habits.AccountController do
  use Habits.Web, :controller

  alias Habits.Session

  def show(conn, _params) do
    account = Session.current_account(conn)
    render(conn, "show.html", account: account)
  end
end
