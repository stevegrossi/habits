defmodule Habits.Achievements.CheckInCount do
  @moduledoc false

  use Habits.Achievements.Achievement

  alias Habits.{Repo, Accounts.Account}
  alias HabitsWeb.{Habit}

  defp value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, [:habits, :check_ins]))
  end
  defp value_for(%Habit{} = habit) do
    Habit.check_in_count(habit)
  end
end
