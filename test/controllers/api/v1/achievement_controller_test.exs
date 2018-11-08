defmodule Habits.API.V1.AchievementControllerTest do
  use HabitsWeb.ConnCase

  describe ".index" do
    test "returns achievements for an account", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      Factory.insert(:check_in, habit: habit)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(Routes.api_v1_account_achievements_path(conn, :index))

      assert json_response(conn, :ok) == %{
               "achievements" => [
                 %{
                   "name" => "Check In 100 Times",
                   "threshold" => 100,
                   "value" => 1
                 },
                 %{
                   "name" => "Check In 1,000 Times",
                   "threshold" => 1_000,
                   "value" => 1
                 },
                 %{
                   "name" => "Check In 10,000 Times",
                   "threshold" => 10_000,
                   "value" => 1
                 },
                 %{
                   "name" => "Track 5 Habits",
                   "threshold" => 5,
                   "value" => 1
                 },
                 %{
                   "name" => "Track 10 Habits",
                   "threshold" => 10,
                   "value" => 1
                 }
               ]
             }
    end

    test "returns achievements for a specific habit", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      Factory.insert(:check_in, habit: habit)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(Routes.api_v1_habit_achievements_path(conn, :index, habit.id))

      assert json_response(conn, :ok) == %{
               "achievements" => [
                 %{
                   "name" => "Check In 100 Times",
                   "threshold" => 100,
                   "value" => 1
                 },
                 %{
                   "name" => "Check In 1,000 Times",
                   "threshold" => 1_000,
                   "value" => 1
                 },
                 %{
                   "name" => "Week-long Streak",
                   "threshold" => 7,
                   "value" => 1
                 },
                 %{
                   "name" => "Month-long Streak",
                   "threshold" => 30,
                   "value" => 1
                 },
                 %{
                   "name" => "Year-long Streak!",
                   "threshold" => 365,
                   "value" => 1
                 }
               ]
             }
    end
  end
end
