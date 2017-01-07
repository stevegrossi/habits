defmodule Habits.CheckIn do
  @moduledoc """
  Data logic for the CheckIn domain model, which belongs to a Habit. Habits have
  multiple CheckIns, but at most one per calendar date.
  """

  use Habits.Web, :model

  alias Habits.{Repo, Habit, CheckIn}

  schema "check_ins" do
    field :date, Timex.Ecto.Date
    belongs_to :habit, Habits.Habit

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
      |> Repo.one

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
