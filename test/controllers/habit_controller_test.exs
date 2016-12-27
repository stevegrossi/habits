defmodule Habits.HabitControllerTest do
  use Habits.ConnCase

  alias Habits.Habit

  @valid_attrs %{name: "Test Habit"}
  @invalid_attrs %{name: ""}

  test "renders the react container", %{conn: conn} do
    account = Factory.insert(:account)

    conn =
      build_conn()
      |> assign(:current_account, account)
      |> get(habit_path(conn, :index))

    assert html_response(conn, 200) =~ "Loading..."
  end

  test "renders form for new resources", %{conn: conn} do
    account = Factory.insert(:account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> get(habit_path(conn, :new))

    assert html_response(conn, 200) =~ "New habit"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    account = Factory.insert(:account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> post(habit_path(conn, :create), habit: @valid_attrs)

    assert redirected_to(conn) == habit_path(conn, :index)
    assert Repo.get_by(Habit, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    account = Factory.insert(:account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> post(habit_path(conn, :create), habit: @invalid_attrs)

    assert html_response(conn, 200) =~ "New habit"
  end

  test "shows chosen resource", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> get(habit_path(conn, :show, habit))

    assert html_response(conn, 200) =~ habit.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    account = Factory.insert(:account)

    assert_raise Ecto.NoResultsError, fn ->
      build_conn()
        |> assign(:current_account, account)
        |> get(habit_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> get(habit_path(conn, :edit, habit))

    assert html_response(conn, 200) =~ "Edit habit"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> put(habit_path(conn, :update, habit), habit: @valid_attrs)

    assert redirected_to(conn) == habit_path(conn, :index)
    assert Repo.get_by(Habit, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> put(habit_path(conn, :update, habit), habit: @invalid_attrs)

    assert html_response(conn, 200) =~ "Edit habit"
  end

  test "deletes chosen resource", %{conn: conn} do
    account = Factory.insert(:account)
    habit = Factory.insert(:habit, account: account)

    conn = build_conn()
      |> assign(:current_account, account)
      |> delete(habit_path(conn, :delete, habit))

    assert redirected_to(conn) == habit_path(conn, :index)
    refute Repo.get(Habit, habit.id)
  end
end
