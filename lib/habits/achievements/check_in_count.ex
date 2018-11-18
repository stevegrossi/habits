defmodule Habits.Achievements.CheckInCount do
  @moduledoc false

  use Habits.Achievements.Achievement

  alias Habits.Habits.Habit
  alias Habits.{Repo, Habits, Accounts.Account}

  defp value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, [:habits, :check_ins]))
  end

  defp value_for(%Habit{} = habit) do
    Habits.check_in_count(habit)
  end
end
