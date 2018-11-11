defmodule Habits.Auth do
  @moduledoc """
  Responsible for authenticating accounts such as when logging in or out.
  """

  alias Habits.Repo
  alias Habits.Auth.Session

  def get_account_id_from_token(token) do
    case Repo.get_by(Session, token: token) do
      nil -> {:error, "Invalid token"}
      session -> {:ok, session.account_id}
    end
  end
end
