defmodule Achievement.HabitCount do

  alias Habits.{Repo, Account}

  @enforce_keys ~w(name threshold value)a
  defstruct ~w(name threshold value)a

  def new(%Account{} = account, threshold) when is_integer(threshold) do
    %__MODULE__{
      name: "Track #{threshold} Habits",
      threshold: threshold,
      value: Repo.count(Ecto.assoc(account, :habits))
    }
  end
end
