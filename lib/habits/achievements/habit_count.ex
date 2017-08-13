defmodule Habits.Achievements.HabitCount do
  @moduledoc false

  use Habits.Achievements.Achievement

  alias Habits.Repo
  alias HabitsWeb.Account

  defp value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, :habits))
  end
end
