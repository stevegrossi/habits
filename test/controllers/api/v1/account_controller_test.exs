defmodule Habits.API.V1.AccountControllerTest do
  use Habits.ConnCase

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
end
