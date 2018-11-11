defmodule Habits.API.V1.SessionControllerTest do
  use HabitsWeb.ConnCase

  alias Habits.{Accounts}
  alias Habits.Auth.Session
  @valid_attrs %{email: "foo@bar.com", password: "p4ssw0rd"}

  describe ".index" do
    test "lists all sessions for the current account", %{conn: conn} do
      account = Factory.insert(:account)
      session_1 = Factory.insert(:session, account: account)
      session_2 = Factory.insert(:session, account: account)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(Routes.api_v1_session_path(conn, :index))

      assert json_response(conn, 200) == [
               %{
                 "token" => session_2.token,
                 "createdAt" => DateTime.to_iso8601(session_2.inserted_at),
                 "location" => session_2.location
               },
               %{
                 "token" => session_1.token,
                 "createdAt" => DateTime.to_iso8601(session_1.inserted_at),
                 "location" => session_1.location
               }
             ]
    end
  end

  describe ".create" do
    setup %{conn: conn} do
      Accounts.create_account(@valid_attrs)
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "creates and renders a session when data is valid", %{conn: conn} do
      conn = post conn, Routes.api_v1_session_path(conn, :create), account: @valid_attrs
      token = json_response(conn, 201)["data"]["token"]
      assert Repo.get_by(Session, token: token)
    end

    test "does not create session and renders errors when password is invalid", %{conn: conn} do
      conn =
        post conn, Routes.api_v1_session_path(conn, :create),
          account: Map.put(@valid_attrs, :password, "notright")

      assert json_response(conn, :unauthorized)["errors"] != %{}
    end

    test "does not create session and renders errors when email is invalid", %{conn: conn} do
      conn =
        post conn, Routes.api_v1_session_path(conn, :create),
          account: Map.put(@valid_attrs, :email, "not@found.com")

      assert json_response(conn, :unauthorized)["errors"] != %{}
    end
  end

  describe ".delete" do
    test "deletes the requested session", %{conn: conn} do
      account = Factory.insert(:account)
      session = Factory.insert(:session, account: account)

      conn =
        conn
        |> assign(:current_account, account)
        |> delete(Routes.api_v1_session_path(conn, :delete, session.token))

      assert json_response(conn, :ok) == %{
               "success" => true
             }

      refute Repo.get(Session, session.id)
    end
  end
end
