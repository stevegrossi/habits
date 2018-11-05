defmodule Habits.RepoTest do
  use Habits.DataCase

  alias Habits.Repo
  alias HabitsWeb.Habit

  test "count returns the number of results" do
    Factory.insert_list(2, :habit)

    assert Repo.count(Habit) == 2
  end
end
