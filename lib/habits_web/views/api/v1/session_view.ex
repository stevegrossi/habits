defmodule HabitsWeb.API.V1.SessionView do
  use Habits.Web, :view

  def render("index.json", %{sessions: sessions}) do
    render_many(sessions, __MODULE__, "session.json")
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, __MODULE__, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{
      token: session.token,
      createdAt: session.inserted_at,
      location: session.location
    }
  end

  def render("error.json", _anything) do
    %{errors: "failed to authenticate"}
  end

  def render("success.json", %{}) do
    %{success: true}
  end
end
