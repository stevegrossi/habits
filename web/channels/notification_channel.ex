defmodule Habits.NotificationChannel do
  @moduledoc false

  use Habits.Web, :channel

  def join("notifications", _, socket) do
    {:ok, socket}
  end
end
