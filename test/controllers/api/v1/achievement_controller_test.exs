defmodule Habits.API.V1.AchievementControllerTest do
  use Habits.ConnCase

  describe ".index" do

    test "returns info about the current account", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      Factory.insert(:check_in, habit: habit)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(api_v1_account_achievements_path(conn, :index))

      assert json_response(conn, :ok) == %{
        "achievements" => [
          %{
            "name" => "100 Check-Ins",
            "description" => "Check in 100 times",
            "threshold" => 100,
            "value" => 1
          },
          %{
            "name" => "1,000 Check-Ins",
            "description" => "Check in 1,000 times",
            "threshold" => 1_000,
            "value" => 1
          },
          %{
            "name" => "10,000 Check-Ins",
            "description" => "Check in 10,000 times",
            "threshold" => 10_000,
            "value" => 1
          }
        ]
      }
    end
  end
end
