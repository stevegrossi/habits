defmodule Achievement.HabitCount do

  alias Habits.{Repo, Account}

  @enforce_keys ~w(name threshold value)a
  defstruct ~w(name threshold value)a

  def new(%Account{} = account, threshold, name) when is_integer(threshold)
                                                  and is_binary(name) do
    %__MODULE__{
      name: name,
      threshold: threshold,
      value: Repo.count(Ecto.assoc(account, :habits))
    }
  end
end
