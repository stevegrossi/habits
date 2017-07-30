defmodule Habits.Achievements.CheckInCount do
  @moduledoc false

  use Habits.Achievements.Achievement

  alias Habits.Repo
  alias HabitsWeb.{Account, Habit}

  def value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, [:habits, :check_ins]))
  end
  def value_for(%Habit{} = habit) do
    Habit.check_in_count(habit)
  end
end
