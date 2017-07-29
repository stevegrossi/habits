defmodule Achievement.HabitCount do
  @moduledoc false

  use Achievement
  alias Habits.Repo
  alias HabitsWeb.Account

  def value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, :habits))
  end
end
