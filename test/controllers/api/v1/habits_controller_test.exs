defmodule Habits.API.V1.HabitControllerTest do
  use HabitsWeb.ConnCase

  alias HabitsWeb.{CheckIn, Habit}

  describe ".index" do

    test "renders a list of habits", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      Factory.insert(:check_in, habit: habit, date: Habits.Date.today)
      Factory.insert(:check_in, habit: habit, date: Habits.Date.yesterday)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(Routes.api_v1_habit_path(conn, :index), date: Habits.Date.today_string)

      assert json_response(conn, :ok) == [
        %{
          "id" => habit.id,
          "name" => habit.name,
          "checkedIn" => true,
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
        |> get(Routes.api_v1_habit_path(conn, :show, habit.id))

      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => habit.name,
        "currentStreak" => 1,
        "longestStreak" => 1,
        "checkInData" => [1]
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
        |> delete(Routes.api_v1_habit_path(conn, :delete, habit.id))

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
        |> post(Routes.api_v1_habit_path(conn, :create), new_habit_params)

      habit = Repo.get_by(Habit, name: "Make a friend")
      assert habit
      assert json_response(conn, :created) == %{
        "id" => habit.id,
        "name" => habit.name,
        "checkedIn" => false,
        "streak" => 0
      }
    end
  end

  describe ".update" do

    test "updates an existing habit in the current account", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      new_params = %{"name" => "Fight for justice"}

      conn =
        conn
        |> assign(:current_account, account)
        |> patch(Routes.api_v1_habit_path(conn, :update, habit.id), new_params)

      assert Repo.get_by(Habit, name: new_params["name"])
      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => new_params["name"],
        "checkedIn" => false,
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
        |> post(Routes.api_v1_habit_check_in_path(conn, :check_in, habit.id, date: Habits.Date.today_string))

      Repo.get_by(CheckIn, %{habit_id: habit.id, date: Habits.Date.today})

      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => habit.name,
        "checkedIn" => true,
        "streak" => 1
      }
    end

    test "does not create a check-in when one exists", %{conn: conn} do
        account = Factory.insert(:account)
        habit = Factory.insert(:habit, account: account)
        Factory.insert(:check_in, habit: habit, date: Habits.Date.today)

        conn
          |> assign(:current_account, account)
          |> post(Routes.api_v1_habit_check_in_path(conn, :check_in, habit.id, date: Habits.Date.today_string))

        assert Repo.count(CheckIn) == 1
    end

    test "does not check in to another account's habit", %{conn: conn} do
      account = Factory.insert(:account)
      other_account = Factory.insert(:account)
      other_accounts_habit = Factory.insert(:habit, account: other_account)

      conn =
        conn
        |> assign(:current_account, account)
        |> post(Routes.api_v1_habit_check_in_path(conn, :check_in, other_accounts_habit.id, date: Habits.Date.today_string))

      assert json_response(conn, :not_found)["error"] == "Habit not found"
      refute Repo.get_by(CheckIn, %{habit_id: other_accounts_habit.id, date: Habits.Date.today})
    end
  end

  describe ".check_out" do

    test "deletes a check-in", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      check_in = Factory.insert(:check_in, habit: habit, date: Habits.Date.today)

      conn =
        conn
        |> assign(:current_account, account)
        |> delete(Routes.api_v1_habit_check_out_path(conn, :check_out, habit.id, date: Habits.Date.today_string))

      refute Repo.get(CheckIn, check_in.id)

      assert json_response(conn, :ok) == %{
        "id" => habit.id,
        "name" => habit.name,
        "checkedIn" => false,
        "streak" => 0
      }
    end

    test "does not delete another account's check-in", %{conn: conn} do
      account = Factory.insert(:account)
      other_account = Factory.insert(:account)
      other_accounts_habit = Factory.insert(:habit, account: other_account)
      other_accounts_check_in = Factory.insert(:check_in, habit: other_accounts_habit, date: Habits.Date.today)

      conn =
        conn
        |> assign(:current_account, account)
        |> delete(Routes.api_v1_habit_check_out_path(conn, :check_out, other_accounts_habit.id, date: Habits.Date.today_string))

      assert json_response(conn, :not_found)["error"] == "Habit not found"
      assert Repo.get(CheckIn, other_accounts_check_in.id)
    end
  end
end
