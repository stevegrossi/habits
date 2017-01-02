defmodule Habits.API.V1.AccountView do
  use Habits.Web, :view

  alias Habits.{Repo}

  def render("show.json", %{account: account}) do
    %{
      email: account.email,
      totalCheckIns: total_check_ins(account)
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end

  defp total_check_ins(account) do
    account
    |> Ecto.assoc([:habits, :check_ins])
    |> Repo.count
  end
end
