defmodule Habits.AccountsTest do
  use Habits.DataCase

  alias Habits.Accounts

  describe ".time_series_check_in_data" do
    test "returns weekly check-in counts for the specified account" do
      account = Factory.insert(:account)
      habit = Factory.insert(:habit, account: account)
      sunday = ~D[2018-11-11]
      monday = ~D[2018-11-12]
      tuesday = ~D[2018-11-13]
      thursday = ~D[2018-11-15]
      end_date = ~D[2018-11-18]
      Factory.insert(:check_in, habit: habit, date: sunday)
      Factory.insert(:check_in, habit: habit, date: monday)
      Factory.insert(:check_in, habit: habit, date: tuesday)
      Factory.insert(:check_in, habit: habit, date: thursday)

      # Check-ins from other accounts should be ignored
      other_account = Factory.insert(:account)
      other_accounts_habit = Factory.insert(:habit, account: other_account)
      Factory.insert(:check_in, habit: other_accounts_habit, date: thursday)

      result = Accounts.time_series_check_in_data(account, end_date)
      assert result == [1, 3]
    end
  end
end
