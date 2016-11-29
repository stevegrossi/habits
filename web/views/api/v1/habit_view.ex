defmodule Habits.API.V1.HabitView do
  use Habits.Web, :view

  alias Habits.Habit
  alias Habits.Repo

  import Ecto.Query, only: [from: 2]

  def render("index.json", %{habits: habits, date: date}) do
    habits
    |> Enum.map(&habit_data_for_date(&1, date))
    |> Poison.encode!
  end

  def render("show.json", %{habit: habit, date: date}) do
    habit
    |> habit_data_for_date(date)
    |> Poison.encode!
  end

  defp habit_data_for_date(habit, date) do
    %{
      id: habit.id,
      name: habit.name,
      checkInId: check_in_id_for_habit(habit.id, date),
      streak: Habit.get_current_streak(habit)
    }
  end

  def check_in_id_for_habit(habit_id, nil) do
    Repo.one(
      from c in Habits.CheckIn,
      where: c.habit_id == ^habit_id,
      where: c.date == ^Timex.local,
      select: c.id
    )
  end
  def check_in_id_for_habit(habit_id, date) do
    Repo.one(
      from c in Habits.CheckIn,
      where: c.habit_id == ^habit_id,
      where: c.date == ^date,
      select: c.id
    )
  end
end
