defmodule Habits.Number do

  def delimit(number) when is_integer(number) do
    Regex.replace(~r/(\d)(?=(\d{3})+$)/, Integer.to_string(number), "\\1,")
  end
end
