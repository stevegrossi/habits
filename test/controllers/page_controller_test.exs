defmodule Habits.PageControllerTest do
  use Habits.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Habits!"
  end
end
