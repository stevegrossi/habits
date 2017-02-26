defmodule Achievement.CheckInCount do

  alias Habits.{Repo, Account, Habit, Number}

  @enforce_keys ~w(name threshold value)a
  defstruct ~w(name threshold value)a

  def new(%Account{} = account, threshold, name) when is_integer(threshold)
                                                  and is_binary(name) do
    %__MODULE__{
      name: name,
      threshold: threshold,
      value: Repo.count(Ecto.assoc(account, [:habits, :check_ins]))
    }
  end
  def new(%Habit{} = habit, threshold, name) when is_integer(threshold)
                                                  and is_binary(name) do
    %__MODULE__{
      name: name,
      threshold: threshold,
      value: Repo.count(Ecto.assoc(habit, :check_ins))
    }
  end
end
