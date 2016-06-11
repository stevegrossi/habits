defmodule Habits.RegistrationController do
  use Habits.Web, :controller

  alias Habits.Account
  alias Habits.Registration
  alias Habits.Repo

  plug Habits.Plugs.LimitRegistration

  def new(conn, _params) do
    changeset = Account.changeset(%Account{})
    render conn, changeset: changeset
  end

  def create(conn, %{"account" => account_params}) do
    changeset = Account.changeset(%Account{}, account_params)

    if changeset.valid? do
      {:ok, account} = Registration.create(changeset, Repo)
      conn
      |> put_session(:current_account, account.id)
      |> put_flash(:info, "Your account was created!")
      |> redirect(to: "/habits")
    else
      conn
      |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_account)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
