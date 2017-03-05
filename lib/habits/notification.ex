defmodule Habits.Notification do
  alias Habits.Endpoint

  def new(subject, message) when is_binary(subject) and is_binary(message) do
    Endpoint.broadcast("notifications", "notification:new", %{
      subject: subject,
      message: message
    })
  end
end
