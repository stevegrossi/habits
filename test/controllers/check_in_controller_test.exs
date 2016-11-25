defmodule Habits.CheckInControllerTest do
  use Habits.ConnCase

  alias Habits.CheckIn

  test "creates a check-in", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> post(habit_check_in_path(conn, :create, habit.id, date: today_string))

    assert redirected_to(conn) == today_path
    assert get_flash(conn, :info) == "You checked in to #{habit.name}!"
    assert Repo.get_by(CheckIn, %{habit_id: habit.id, date: today_tuple})
  end

  test "does not create a check-in when one exists", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)
    Factory.insert(:check_in, habit: habit, date: Timex.local)

    conn = build_conn()
      |> assign(:current_account, account)
      |> post(habit_check_in_path(conn, :create, habit.id, date: today_string))

    assert redirected_to(conn) == today_path
    assert get_flash(conn, :info) == "You’ve already checked in to #{habit.name}!"
    assert Repo.count(CheckIn) == 1
  end

  test "does not check in to another account's habit", %{conn: conn} do
    account = Factory.insert(:account)
    other_account = Factory.insert(:account)
    other_accounts_habit = Factory.insert(:habit, account: other_account)

    # I should do better than `nil.id`, but for now...
    assert_raise UndefinedFunctionError, fn ->
      build_conn()
        |> assign(:current_account, account)
        |> post(habit_check_in_path(conn, :create, other_accounts_habit.id, date: today_string))
    end

    refute Repo.get_by(CheckIn, %{habit_id: other_accounts_habit.id, date: today_tuple})
  end

  test "deletes a check-in", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)
    check_in = Factory.insert(:check_in, habit: habit, date: Timex.local)

    conn = build_conn()
      |> assign(:current_account, account)
      |> delete(habit_check_in_path(conn, :delete, habit.id, check_in.id, date: today_string))

    assert redirected_to(conn) == today_path
    assert get_flash(conn, :info) == "Removed check-in for #{habit.name}"
    refute Repo.get(CheckIn, check_in.id)
  end

  test "does not delete another account's check-in", %{conn: conn} do
    account = Factory.insert(:account)
    other_account = Factory.insert(:account)
    other_accounts_habit = Factory.insert(:habit, account: other_account)
    other_accounts_check_in = Factory.insert(:check_in, habit: other_accounts_habit, date: Timex.local)

      # I should do better than `nil.id`, but for now...
    assert_raise UndefinedFunctionError, fn ->
     build_conn()
        |> assign(:current_account, account)
        |> delete(habit_check_in_path(conn, :delete, other_accounts_habit.id, other_accounts_check_in.id, date: today_string))
    end

    assert Repo.get(CheckIn, other_accounts_check_in.id)
  end

  defp today_tuple do
    date = Timex.local
    {date.year, date.month, date.day}
  end

  defp today_string do
    Timex.local |> Timex.format!("%F", :strftime)
  end

  defp today_path do
    {year, month, day} = today_tuple
    "/#{year}/#{month}/#{day}"
  end
end
