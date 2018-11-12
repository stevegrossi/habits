defmodule Habits.Habits do
  @moduledoc """
  Core functionality related to managing and checking into habits.
  """

  import Ecto, only: [assoc: 2]
  import Ecto.Query

  alias Habits.Repo
  alias Habits.Accounts.Account

  @doc """
  Returns the list of habits for an Account.

  ## Examples

      iex> Habits.list_habits(%Account{id: 1})
      [%Habit{}, ...]

  """
  def list_habits(%Account{} = account) do
    account
    |> assoc(:habits)
    |> order_by(:name)
    |> Repo.all()
  end
end
