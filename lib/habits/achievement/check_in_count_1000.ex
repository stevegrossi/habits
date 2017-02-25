defmodule Achievement.CheckInCount1000 do

  alias Habits.{Repo, Account}

  @name "1,000 Check-Ins"
  @description "Check in 1,000 times"
  @threshold 1_000

  defstruct name: @name,
            description: @description,
            threshold: @threshold,
            value: nil

  def for(%Account{} = account) do
    value =
      account
      |> Ecto.assoc([:habits, :check_ins])
      |> Repo.count

    %__MODULE__{value: value}
  end
end
