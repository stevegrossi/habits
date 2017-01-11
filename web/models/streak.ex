defmodule Habits.Streak do
  @moduledoc """
  Data logic for streaks of consecutive daily check-ins related to habits.
  """

  use Habits.Web, :model
  alias Habits.Habit

  @primary_key false
  schema "streaks" do
    belongs_to :habit, Habit
    field :start, :date
    field :end, :date
    field :length, :integer
  end
end
