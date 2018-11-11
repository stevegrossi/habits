defmodule Habits.Auth do
  @moduledoc """
  Responsible for authentication of accounts such as when logging in or out.
  """

  import Ecto, only: [assoc: 2]
  # import Ecto.Changeset
  import Ecto.Query

  alias Habits.Repo
  alias Habits.Accounts.Account
  alias Habits.Auth.Session

  def get_account_id_from_token(token) do
    case Repo.get_by(Session, token: token) do
      nil -> {:error, "Invalid token"}
      session -> {:ok, session.account_id}
    end
  end

  def list_sessions(%Account{} = account) do
    account
    |> assoc(:sessions)
    |> order_by(desc: :id)
    |> Repo.all()
  end
end
