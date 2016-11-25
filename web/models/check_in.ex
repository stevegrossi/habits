defmodule Habits.CheckIn do
  use Habits.Web, :model

  schema "check_ins" do
    field :date, Timex.Ecto.Date
    belongs_to :habit, Habits.Habit

    timestamps
  end

  @doc """
  Builds a changeset based on the `check_in` struct and `params`.
  """
  def changeset(check_in, params \\ %{}) do
    check_in
    |> cast(params, [:date, :habit_id])
    |> validate_required([:date, :habit_id])
    |> unique_constraint(:habit_id_date)
  end
end
