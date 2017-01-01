defmodule Habits.TokenAuthenticationTest do
  use Habits.ConnCase

  alias Habits.{TokenAuthentication, Factory}

  @opts TokenAuthentication.init([])

  def put_auth_token_in_header(conn, token) do
    conn
    |> put_req_header("authorization", "Token token=\"#{token}\"")
  end

  test "finds the account by token", %{conn: conn} do
    account = Factory.insert(:account)
    session = Factory.insert(:session, token: "123", account: account)

    conn = conn
    |> put_auth_token_in_header(session.token)
    |> TokenAuthentication.call(@opts)

    assert conn.assigns.current_account
  end

  test "invalid token", %{conn: conn} do
    conn = conn
    |> put_auth_token_in_header("foo")
    |> TokenAuthentication.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "no token", %{conn: conn} do
    conn = TokenAuthentication.call(conn, @opts)
    assert conn.status == 401
    assert conn.halted
  end
end
