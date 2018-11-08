defmodule Habits.DateTest do
  use ExUnit.Case, async: true
  alias Habits.Date

  describe ".shift" do
    test "adds a day to a date" do
      assert Date.shift_days(~D[2016-12-31], 1) == ~D[2017-01-01]
    end

    test "subtracts a day from a date" do
      assert Date.shift_days(~D[2016-03-01], -1) == ~D[2016-02-29]
    end
  end
end
