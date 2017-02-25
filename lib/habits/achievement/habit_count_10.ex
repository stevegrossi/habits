defmodule Achievement.HabitCount10 do

  alias Habits.{Repo, Account}

  @name "Track 10 Habits"
  @threshold 10

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
