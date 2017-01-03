defmodule Habits.API.V1.HabitView do
  use Habits.Web, :view

  alias Habits.{Repo, Habit}
  import Ecto.Query, only: [from: 2]

  def render("index.json", %{habits: habits, date: date}) do
    habits
    |> Enum.map(&habit_data_for_date(&1, date))
  end

  def render("show.json", %{habit: habit}) do
    %{
      id: habit.id,
      name: habit.name,
      totalCheckIns: Habit.check_in_count(habit)
    }
  end

  def render("habit.json", %{habit: habit, date: date}) do
    habit_data_for_date(habit, date)
  end
  def render("habit.json", %{habit: habit}) do
    habit_data_for_date(habit, nil)
  end

  def render("error.json", %{error: message}) do
    %{error: message}
  end

  def render("success.json", %{}) do
    %{success: true}
  end

  defp habit_data_for_date(habit, nil) do
    %{
      id: habit.id,
      name: habit.name,
      checkInId: nil,
      streak: 0
    }
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
