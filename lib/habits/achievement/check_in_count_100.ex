defmodule Achievement.CheckInCount100 do

  alias Habits.{Repo, Account, Habit}

  @name "100 Check-Ins"
  @threshold 100

  defstruct name: @name,
            threshold: @threshold,
            value: nil

  def for(%Account{} = account) do
    value =
      account
      |> Ecto.assoc([:habits, :check_ins])
      |> Repo.count

    %__MODULE__{value: value}
  end

  def for(%Habit{} = habit) do
    value =
      habit
      |> Ecto.assoc(:check_ins)
      |> Repo.count

    %__MODULE__{value: value}
  end
end
