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
      totalCheckIns: Habit.check_in_count(habit),
      currentStreak: Habit.get_current_streak(habit),
      longestStreak: Habit.get_longest_streak(habit)
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
      checkedIn: false,
      streak: 0
    }
  end
  defp habit_data_for_date(habit, date) do
    %{
      id: habit.id,
      name: habit.name,
      checkedIn: checked_into_habit?(habit.id, date),
      streak: Habit.get_current_streak(habit)
    }
  end

  def checked_into_habit?(habit_id, date) do
    Repo.exists?(
      from c in Habits.CheckIn,
      where: c.habit_id == ^habit_id,
      where: c.date == ^date
    )
  end
end
