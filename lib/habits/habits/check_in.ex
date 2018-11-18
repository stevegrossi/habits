defmodule Habits.Habits.CheckIn do
  @moduledoc """
  Data logic for the CheckIn domain model, which belongs to a Habit. Habits have
  multiple CheckIns, but at most one per calendar date.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Habits.Habits.Habit

  schema "check_ins" do
    field(:date, :date)
    belongs_to(:habit, Habit)

    timestamps()
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
