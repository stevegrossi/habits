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
    :calendar.local_time
    |> extract_date_from_erl_datetime
    |> Date.from_erl!
  end

  def yesterday do
    today()
    |> shift_days(-1)
  end

  def today_string do
    today()
    |> Date.to_iso8601
  end

  defp diff_date(date, diff), do: date + diff

  defp extract_date_from_erl_datetime({date, _time}), do: date
end
