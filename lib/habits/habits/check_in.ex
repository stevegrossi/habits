defmodule Habits.Habits.CheckIn do
  @moduledoc """
  Data logic for the CheckIn domain model, which belongs to a Habit. Habits have
  multiple CheckIns, but at most one per calendar date.
  """

  use Ecto.Schema

  import Ecto, only: [assoc: 2]
  import Ecto.Changeset
  import Ecto.Query

  alias Habits.Repo
  alias Habits.Habits.{Habit, CheckIn}

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

  def get_by_date(%Habit{} = habit, date) do
    check_in =
      habit
      |> assoc(:check_ins)
      |> where(date: ^date)
      |> Repo.one()

    {:ok, check_in}
  end

  def create_for_date(habit, date) do
    {:ok, existing_check_in} = get_by_date(habit, date)

    if existing_check_in do
      {:ok, existing_check_in}
    else
      check_in = Repo.insert!(%CheckIn{habit: habit, date: date})
      {:ok, check_in}
    end
  end
end
