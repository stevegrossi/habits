defmodule Habits.Notification do
  alias Habits.Endpoint

  def new(message) when is_binary(message) do
    Endpoint.broadcast("notifications", "notification:new", %{
      message: message
    })
  end
end
