defmodule Habits.Habits do
  @moduledoc """
  Core functionality related to managing and checking into habits.
  """

  import Ecto, only: [assoc: 2]
  import Ecto.Query

  alias Habits.Repo
  alias Habits.Accounts.Account
  alias Habits.Habits.Habit

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

  @doc """
  Creates a Habit within an Account.

  ## Examples

      iex> Habits.create_habit!(account, %{name: "Do Elixir"})
      %Habit{}

      iex> Habits.create_habit!(account, %{name: nil})
      ** (Error)

  """
  def create_habit!(%Account{id: account_id}, attrs \\ %{}) do
    %Habit{account_id: account_id}
    |> Habit.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a habit.

  ## Examples

      iex> Habits.update_habit!(account, habit_id, %{name: "Exercise"})
      %Habit{}

      iex> Habits.update_habit!(account, habit_id, %{name: nil})
      ** (Error)

  """
  def update_habit!(%Account{} = account, habit_id, attrs \\ %{}) do
    account
    |> get_habit!(habit_id)
    |> Habit.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a Habit from the given account.

  ## Examples

      iex> Habits.delete_habit!(account, habit_id)
      %Habit{}

      iex> Habits.delete_habit!(account, nil)
      ** (Error)

  """
  def delete_habit!(%Account{} = account, habit_id) do
    account
    |> get_habit!(habit_id)
    |> Repo.delete!()
  end
end
