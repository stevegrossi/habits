defmodule Achievement.HabitCount do

  use Achievement
  alias Habits.{Repo, Account}

  def new(%Account{} = account, threshold, name) when is_integer(threshold)
                                                  and is_binary(name) do
    %__MODULE__{
      name: name,
      threshold: threshold,
      value: Repo.count(Ecto.assoc(account, :habits))
    }
  end
end
