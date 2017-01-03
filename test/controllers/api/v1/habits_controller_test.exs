defmodule Habits.API.V1.HabitControllerTest do
  use Habits.ConnCase

  alias Habits.{CheckIn, Habit}

  describe ".index" do

    test "renders a list of habits", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      today_check_in = Factory.insert(:check_in, habit: habit, date: today_date)
      Factory.insert(:check_in, habit: habit, date: yesterday_date)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(api_v1_habit_path(conn, :index), date: Date.to_string(today_date))

      assert json_response(conn, :ok) == [
        %{
          "id" => habit.id,
          "name" => habit.name,
          "checkInId" => today_check_in.id,
          "streak" => 2
        }
      ]
    end
  end

  describe ".show" do

    test "renders a single habit", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      Factory.insert(:check_in, habit: habit)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(api_v1_habit_path(conn, :show, habit.id))

      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => habit.name,
        "totalCheckIns" => 1
      }
    end
  end

  describe ".delete" do

    test "deletes a habit from the current account", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      check_in = Factory.insert(:check_in, habit: habit)

      conn =
        conn
        |> assign(:current_account, account)
        |> delete(api_v1_habit_path(conn, :delete, habit.id))

      assert json_response(conn, :ok) == %{
        "success" => true
      }

      refute Repo.get(Habit, habit.id)
      refute Repo.get(CheckIn, check_in.id)
    end
  end

  describe ".create" do

    test "creates a habit in the current account", %{conn: conn} do
      account = Factory.insert(:account)
      new_habit_params = %{"habit" => %{"name" => "Make a friend"}}

      conn =
        conn
        |> assign(:current_account, account)
        |> post(api_v1_habit_path(conn, :create), new_habit_params)

      habit = Repo.get_by(Habit, name: "Make a friend")
      assert habit
      assert json_response(conn, :created) == %{
        "id" => habit.id,
        "name" => habit.name,
        "checkInId" => nil,
        "streak" => 0
      }
    end
  end

  describe ".check_in" do

    test "checks in to a habit", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)

      conn = conn
        |> assign(:current_account, account)
        |> post(api_v1_habit_check_in_path(conn, :check_in, habit.id, date: today_string))

      new_check_in = Repo.get_by(CheckIn, %{habit_id: habit.id, date: today_tuple})

      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => habit.name,
        "checkInId" => new_check_in.id,
        "streak" => 1
      }
    end

    test "does not create a check-in when one exists", %{conn: conn} do
        account = Factory.insert(:account)
        habit = Factory.insert(:habit, account: account)
        Factory.insert(:check_in, habit: habit, date: today_tuple)

        conn
          |> assign(:current_account, account)
          |> post(api_v1_habit_check_in_path(conn, :check_in, habit.id, date: today_string))

        assert Repo.count(CheckIn) == 1
    end

    test "does not check in to another account's habit", %{conn: conn} do
      account = Factory.insert(:account)
      other_account = Factory.insert(:account)
      other_accounts_habit = Factory.insert(:habit, account: other_account)

      conn =
        conn
        |> assign(:current_account, account)
        |> post(api_v1_habit_check_in_path(conn, :check_in, other_accounts_habit.id, date: today_string))

      assert json_response(conn, :not_found)["error"] == "Habit not found"
      refute Repo.get_by(CheckIn, %{habit_id: other_accounts_habit.id, date: today_tuple})
    end
  end

  describe ".check_out" do

    test "deletes a check-in", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      check_in = Factory.insert(:check_in, habit: habit, date: today_tuple)

      conn =
        conn
        |> assign(:current_account, account)
        |> post(api_v1_habit_check_out_path(conn, :check_out, habit.id, date: today_string))

      refute Repo.get(CheckIn, check_in.id)

      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => habit.name,
        "checkInId" => nil,
        "streak" => 0
      }
    end

    test "does not delete another account's check-in", %{conn: conn} do
      account = Factory.insert(:account)
      other_account = Factory.insert(:account)
      other_accounts_habit = Factory.insert(:habit, account: other_account)
      other_accounts_check_in = Factory.insert(:check_in, habit: other_accounts_habit, date: today_tuple)

      conn =
        conn
        |> assign(:current_account, account)
        |> post(api_v1_habit_check_out_path(conn, :check_out, other_accounts_habit.id, date: today_string))

      assert json_response(conn, :not_found)["error"] == "Habit not found"
      assert Repo.get(CheckIn, other_accounts_check_in.id)
    end
  end

  defp today_date do
    Timex.local
    |> Timex.to_date
  end

  defp yesterday_date do
    Timex.local
    |> Timex.shift(days: -1)
    |> Timex.to_date
  end

  defp today_string do
    Timex.local
    |> Timex.format!("%F", :strftime)
  end

  defp today_tuple do
    %DateTime{year: year, month: month, day: day} = Timex.local
    {year, month, day}
  end
end
