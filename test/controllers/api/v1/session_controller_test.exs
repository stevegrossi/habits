defmodule Habits.API.V1.SessionControllerTest do
  use Habits.ConnCase

  alias Habits.{Session, Account}
  @valid_attrs %{email: "foo@bar.com", password: "p4ssw0rd"}

  describe ".create" do

    setup %{conn: conn} do
      changeset = Account.changeset(%Account{}, @valid_attrs)
      Repo.insert(changeset)
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "creates and renders resource when data is valid", %{conn: conn} do
      conn = post conn, api_v1_session_path(conn, :create), account: @valid_attrs
      token = json_response(conn, 201)["data"]["token"]
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

  describe ".delete" do

    test "deletes the requested session", %{conn: conn} do
      account = Factory.insert(:account)
      session = Factory.insert(:session, account: account)
      conn =
        conn
        |> assign(:current_account, account)
        |> delete(api_v1_session_path(conn, :delete, session.token))

      assert conn.status == 204
      refute Repo.get(Session, session.id)
    end

    test "does not delete another account's session", %{conn: conn} do
      account = Factory.insert(:account)
      Factory.insert(:session, account: account)
      other_accounts_session = Factory.insert(:session)
      conn =
        conn
        |> assign(:current_account, account)
        |> delete(api_v1_session_path(conn, :delete, other_accounts_session.token))

      assert conn.status == 404
      assert Repo.get(Session, other_accounts_session.id)
    end
  end
end
