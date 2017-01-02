defmodule Habits.API.V1.AccountView do
  use Habits.Web, :view

  alias Habits.{Repo, Account}

  def render("show.json", %{account: account}) do
    account
    |> account_data
    |> Poison.encode!
  end

  defp account_data(account) do
    %{
      email: account.email,
      totalCheckIns: total_check_ins(account)
    }
  end

  defp total_check_ins(account) do
    account
    |> Ecto.assoc(:habits)
    |> Repo.all
    |> Ecto.assoc(:check_ins)
    |> Repo.count
  end
end
