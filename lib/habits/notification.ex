defmodule Habits.Notification do
  @moduledoc """
  Responsible for sending notification messages to the user.
  """

  alias HabitsWeb.Endpoint

  def new(subject, message) when is_binary(subject) and is_binary(message) do
    Endpoint.broadcast("notifications", "notification:new", %{
      subject: subject,
      message: message
    })
  end
end
