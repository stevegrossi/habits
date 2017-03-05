defmodule Habits.Congratulations do
  require Ecto.Query
  alias Habits.{Notification, Repo, CheckIn}

  def for(%CheckIn{habit_id: habit_id}) do
    check_in_count = CheckIn.count_for_habit(habit_id)

    if rem(check_in_count, 10) == 0 do
      Notification.new("Checked in #{check_in_count} times!")
    end
  end
end
