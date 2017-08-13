defmodule HabitsWeb.API.V1.AccountView do
  use Habits.Web, :view

  alias Habits.{Accounts}

  def render("show.json", %{account: account}) do
    %{
      email: account.email,
      checkInData: Accounts.time_series_check_in_data(account)
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
