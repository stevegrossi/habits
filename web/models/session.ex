defmodule Habits.Session do
  @moduledoc """
  Logic for authenticating a user.
  """

  alias Habits.Account
  alias Habits.Repo

  def login(params, _repo) do
    account = Repo.get_by(Account, email: String.downcase(params["email"]))
    case authenticate(account, params["password"]) do
      true -> {:ok, account}
      _    -> :error
    end
  end

  defp authenticate(nil, _password), do: false
  defp authenticate(account, given_password) do
    Comeonin.Bcrypt.checkpw(given_password, account.encrypted_password)
  end
end
