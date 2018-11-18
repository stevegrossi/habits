defmodule HabitsWeb.API.V1.HabitView do
  use Habits.Web, :view

  alias Habits.Habits.Habit
  alias Habits.Habits

  def render("index.json", %{habits: habits, date: date}) do
    render_many(habits, __MODULE__, "habit.json", %{date: date})
  end

  def render("show.json", %{habit: habit}) do
    %{
      id: habit.id,
      name: habit.name,
      currentStreak: Habits.get_current_streak(habit),
      longestStreak: Habits.get_longest_streak(habit),
      checkInData: Habit.check_in_data(habit)
    }
  end

  def render("habit.json", %{habit: habit, date: date}) do
    habit_data_for_date(habit, date)
  end

  def render("habit.json", %{habit: habit}) do
    habit_data_for_new_habit(habit)
  end

  def render("error.json", %{error: message}) do
    %{error: message}
  end

  def render("success.json", %{}) do
    %{success: true}
  end

  defp habit_data_for_date(habit, date) do
    %{
      id: habit.id,
      name: habit.name,
      checkedIn: Habit.checked_in?(habit, date),
      streak: Habits.get_current_streak(habit)
    }
  end

  defp habit_data_for_new_habit(habit) do
    %{
      id: habit.id,
      name: habit.name,
      checkedIn: false,
      streak: 0
    }
  end
end
