defmodule Achievement.CheckInCount do

  alias Habits.{Repo, Account, Habit, Number}

  @enforce_keys ~w(name threshold value)a
  defstruct ~w(name threshold value)a

  def new(%Account{} = account, threshold) when is_integer(threshold) do
    %__MODULE__{
      name: "Check In #{Number.delimit(threshold)} Times",
      threshold: threshold,
      value: Repo.count(Ecto.assoc(account, [:habits, :check_ins]))
    }
  end
  def new(%Habit{} = habit, threshold) when is_integer(threshold) do
    %__MODULE__{
      name: "Check In #{Number.delimit(threshold)} Times",
      threshold: threshold,
      value: Repo.count(Ecto.assoc(habit, :check_ins))
    }
  end
end
