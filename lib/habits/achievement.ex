defmodule Achievement do

  alias Habits.{Account, Habit}

  def all_for(%Account{} = account) do
    [
      Achievement.CheckInCount100.for(account),
      Achievement.CheckInCount1000.for(account),
      Achievement.CheckInCount10000.for(account)
    ]
  end
end
