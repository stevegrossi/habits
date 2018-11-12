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

  @doc """
  Gets a single habit from an Account.

  Raises `Ecto.NoResultsError` if the Habit does not exist.

  ## Examples

      iex> Habits.get_habit!(account, 123)
      %Habit{}

      iex> Habits.get_habit!(account, 0)
      ** (Ecto.NoResultsError)

  """
  def get_habit!(%Account{} = account, habit_id) do
    account
    |> assoc(:habits)
    |> Repo.get!(habit_id)
  end
end
