defmodule Habits.API.V1.AccountControllerTest do
  use Habits.ConnCase

  alias Habits.{Account, Session}

  describe ".show" do

    test "returns info about the current account", %{conn: conn} do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      Factory.insert(:check_in, habit: habit)

      conn =
        conn
        |> assign(:current_account, account)
        |> get(api_v1_account_path(conn, :show))

      assert json_response(conn, 200) == Poison.encode!(
        %{
          email: account.email,
          totalCheckIns: 1
        }
      )
    end
  end

  describe ".create" do

    test "creates a new account and signs in", %{conn: conn} do
      data = %{
        "account" => %{
          email: "new@habits.ai",
          password: "p4ssw0rd"
        }
      }
      conn = post(conn, api_v1_account_path(conn, :create), data)

      account = Repo.get_by(Account, email: "new@habits.ai")
      assert account
      session = Repo.get_by(Session, account_id: account.id)
      assert session

      assert json_response(conn, :created)["data"]["token"] == session.token
    end

    test "does not create a new account if one exists", %{conn: conn} do
      Factory.insert(:account)
      data = %{
        "account" => %{
          email: "new@habits.ai",
          password: "p4ssw0rd"
        }
      }
      conn = post(conn, api_v1_account_path(conn, :create), data)

      refute Repo.get_by(Account, email: "new@habits.ai")
      assert json_response(conn, :forbidden) == %{
        "error" => "An account already exists. Please log in."
      }
    end
  end
end
