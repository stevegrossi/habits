defmodule HabitsWeb.API.V1.AccountView do
  use Habits.Web, :view

  alias Habits.{Accounts.Account}

  def render("show.json", %{account: account}) do
    %{
      email: account.email,
      checkInData: Account.check_in_data(account)
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
