defmodule Achievement.CheckInCount do
  @moduledoc false

  use Achievement
  alias Habits.{Repo, Account, Habit}

  def value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, [:habits, :check_ins]))
  end
  def value_for(%Habit{} = habit) do
    Repo.count(Ecto.assoc(habit, :check_ins))
  end
end
