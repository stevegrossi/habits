defmodule Achievement.HabitCount5 do

  alias Habits.{Repo, Account}

  @name "Track 5 Habits"
  @threshold 5

  defstruct name: @name,
            threshold: @threshold,
            value: nil

  def for(%Account{} = account) do
    value =
      account
      |> Ecto.assoc(:habits)
      |> Repo.count

    %__MODULE__{value: value}
  end
end
