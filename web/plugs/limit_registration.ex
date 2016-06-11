defmodule Habits.Plugs.LimitRegistration do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Habits.Repo
  alias Habits.Account

  def init(opts), do: opts

  def call(conn, _opts) do
    if Repo.exists?(Account) do
      conn
      |> put_flash(:error, "An account already exists. Please log in.")
      |> redirect(to: "/login")
      |> halt
    else
      conn
    end
  end
end
