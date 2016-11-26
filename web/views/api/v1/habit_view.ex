defmodule Habits.API.V1.HabitView do
  use Habits.Web, :view

  alias Habits.Habit
  alias Habits.Repo

  import Ecto.Query, only: [from: 2]

  def render("index.json", %{habits: habits, date: date}) do
    habits
    |> Enum.map(fn(habit) ->
         %{
           id: habit.id,
           name: habit.name,
           checkInId: check_in_id_for_habit(habit.id, date),
           streak: Habit.get_current_streak(habit)
         }
       end)
    |> Poison.encode!
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
