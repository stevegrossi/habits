defmodule Achievement.HabitCount do

  use Achievement
  alias Habits.{Repo, Account}

  def value_for(%Account{} = account) do
    Repo.count(Ecto.assoc(account, :habits))
  end
end
