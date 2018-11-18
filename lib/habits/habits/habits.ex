defmodule Habits.Habits do
  @moduledoc """
  Core functionality related to managing and checking into habits.
  """

  import Ecto, only: [assoc: 2]
  import Ecto.Query

  alias Habits.{Repo, Congratulations}
  alias Habits.Accounts.Account
  alias Habits.Habits.{Habit, CheckIn, Streak}

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
  Safely gets a single habit from an Account.

  ## Examples

      iex> Habits.get_habit(account, 123)
      {:ok, %Habit{}}

      iex> Habits.get_habit(account, 0)
      {:error, "Habit not found"}

  """
  def get_habit(%Account{} = account, habit_id) do
    habit =
      account
      |> assoc(:habits)
      |> Repo.get(habit_id)

    if habit do
      {:ok, habit}
    else
      {:error, "Habit not found"}
    end
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

  @doc """
  Creates a CheckIn for an Account’s Habit on a given date. The date can be
  either a Date struct or an ISO8601-formatted string, e.g. "YYYY-MM-DD".

  ## Examples

      iex> Habits.check_in(account, habit_id, ~D[...])
      {:ok, %Habit{}, %CheckIn{}}

      iex> Habits.check_in(account, 0, ~D[...])
      {:error, "Habit not found"}

  """
  def check_in(%Account{} = account, habit_id, date_string) when is_binary(date_string) do
    check_in(account, habit_id, Date.from_iso8601!(date_string))
  end

  def check_in(%Account{} = account, habit_id, date) do
    with {:ok, habit} <- get_habit(account, habit_id),
         {:ok, check_in} <- create_check_in_for_date(habit, date) do
      Congratulations.for(habit)
      {:ok, habit, check_in}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  Deletes the CheckIn for an Account’s Habit on a given date. The date can be
  either a Date struct or an ISO8601-formatted string, e.g. "YYYY-MM-DD".

  ## Examples

      iex> Habits.check_out(account, habit_id, ~D[...])
      {:ok, %Habit{}, %CheckIn{}}

      iex> Habits.check_out(account, 0, ~D[...])
      {:error, "Habit not found"}

  """
  def check_out(%Account{} = account, habit_id, date_string) when is_binary(date_string) do
    check_out(account, habit_id, Date.from_iso8601!(date_string))
  end

  def check_out(%Account{} = account, habit_id, date) do
    with {:ok, habit} <- get_habit(account, habit_id),
         {:ok, check_in} <- get_check_in_by_date(habit, date) do
      deleted_check_in = Repo.delete!(check_in)
      {:ok, habit, deleted_check_in}
    else
      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  Returns the count of all-time CheckIns for the given Habit.
  """
  def check_in_count(%Habit{} = habit) do
    habit
    |> assoc(:check_ins)
    |> Repo.count()
  end

  @doc """
  The current streak is the number of consecutive daily check-ins
  for a habit up until yesterday, or today if you’ve checked in today.
  """
  def get_current_streak(habit) do
    habit
    |> assoc(:streaks)
    |> Streak.current()
  end

  @doc """
  Returns the longest streak of consecutive daily check-ins for a habit
  """
  def get_longest_streak(habit) do
    habit
    |> assoc(:streaks)
    |> Streak.longest()
  end

  @doc """
  Return whether a CheckIn exists for the given habit and date
  """
  def checked_in_on?(%Habit{} = habit, date) do
    habit
    |> assoc(:check_ins)
    |> where(date: ^date)
    |> Repo.exists?()
  end

  defp get_check_in_by_date(%Habit{} = habit, date) do
    check_in =
      habit
      |> assoc(:check_ins)
      |> where(date: ^date)
      |> Repo.one()

    {:ok, check_in}
  end

  defp create_check_in_for_date(habit, date) do
    {:ok, existing_check_in} = get_check_in_by_date(habit, date)

    if existing_check_in do
      {:ok, existing_check_in}
    else
      check_in = Repo.insert!(%CheckIn{habit: habit, date: date})
      {:ok, check_in}
    end
  end
end
