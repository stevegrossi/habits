defmodule Habits.Date do

  def shift_days(date, diff_days) do
    date
    |> Date.to_erl
    |> :calendar.date_to_gregorian_days
    |> diff_date(diff_days)
    |> :calendar.gregorian_days_to_date()
    |> Date.from_erl!
  end

  def today do
    Timex.to_date(Timex.local)
  end

  defp diff_date(date, diff), do: date + diff
end
