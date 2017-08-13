defmodule Habits.NotificationChannelTest do
  use Habits.ChannelCase
  alias HabitsWeb.UserSocket

  test "authenticates to the socket and receives notifications" do
    account = Factory.insert(:account)
    session = Factory.insert(:session, account: account)

    assert {:ok, socket} = connect(UserSocket, %{"token" => session.token})
    assert {:ok, _, _socket} = subscribe_and_join(socket, "notifications")

    Habits.Notification.new("My Subject", "My Message")
    assert_push "notification:new", %{subject: "My Subject", message: "My Message"}
  end

  test "cannot authenticate with an invalid token" do
    assert :error = connect(UserSocket, %{"token" => "nope"})
  end
end
