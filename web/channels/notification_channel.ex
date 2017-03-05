defmodule Habits.NotificationChannel do
  use Habits.Web, :channel

  def join("notifications", _, socket) do
    {:ok, socket}
  end
end
