defmodule Habits.NumberTest do
  use ExUnit.Case, async: true
  alias Habits.Number

  describe ".delimit" do

    test "adds commas between sets of three digits" do
      assert Number.delimit(100) == "100"
      assert Number.delimit(1000) == "1,000"
      assert Number.delimit(10_000) == "10,000"
      assert Number.delimit(1_000_000_000) == "1,000,000,000"
    end
  end
end
