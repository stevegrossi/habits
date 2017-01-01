defmodule Habits.API.V1.SessionControllerTest do
  use Habits.ConnCase

  alias Habits.Session
  alias Habits.Account
  @valid_attrs %{email: "foo@bar.com", password: "p4ssw0rd"}

  setup %{conn: conn} do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    Repo.insert(changeset)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_session_path(conn, :create), account: @valid_attrs
    assert token = json_response(conn, 201)["data"]["token"]
    assert Repo.get_by(Session, token: token)
  end

  test "does not create resource and renders errors when password is invalid", %{conn: conn} do
    conn = post conn, api_v1_session_path(conn, :create), account: Map.put(@valid_attrs, :password, "notright")
    assert json_response(conn, 401)["errors"] != %{}
  end

  test "does not create resource and renders errors when email is invalid", %{conn: conn} do
    conn = post conn, api_v1_session_path(conn, :create), account: Map.put(@valid_attrs, :email, "not@found.com")
    assert json_response(conn, 401)["errors"] != %{}
  end

end
