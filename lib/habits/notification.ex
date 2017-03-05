defmodule Habits.Notification do
  alias Habits.Endpoint

  def new(message) do
    Endpoint.broadcast("notifications", "notification:new", %{
      message: message
    })
  end
end
