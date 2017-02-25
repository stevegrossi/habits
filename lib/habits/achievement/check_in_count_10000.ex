defmodule Achievement.CheckInCount10000 do

  alias Habits.{Repo, Account}

  @name "10,000 Check-Ins"
  @description "Check in 10,000 times"
  @threshold 10_000

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
