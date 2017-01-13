defmodule Habits.Streak do
  @moduledoc """
  Data logic for streaks of consecutive daily check-ins related to habits.
  """

  use Habits.Web, :model
  alias Habits.{Repo, Habit}

  @primary_key false
  schema "streaks" do
    belongs_to :habit, Habit
    field :start, :date
    field :end, :date
    field :length, :integer
  end

  def current(queryable) do
    queryable
    |> where([s], s.end >= ^Habits.Date.yesterday)
    |> select([s], s.length)
    |> Repo.one || 0
  end

  def longest(queryable \\ __MODULE__) do
    queryable
    |> select([s], max(s.length))
    |> Repo.one || 0
  end
end
