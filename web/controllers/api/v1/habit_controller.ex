defmodule Habits.API.V1.HabitController do
  use Habits.Web, :controller

  alias Habits.Session

  def index(conn, %{"date" => date_string}) do
    {:ok, date} = Timex.parse(date_string, "%F", :strftime)
    habits = Repo.all(assoc(Session.current_account(conn), :habits))

    render conn, "index.json", habits: habits, date: date
  end
end
