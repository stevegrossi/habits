defmodule Habits.Factory do
  use ExMachina.Ecto, repo: Habits.Repo

  def factory(:account) do
    %Habits.Account{
      email: sequence(:email, &"email-#{&1}@example.com"),
      encrypted_password: "password"
    }
  end

  def factory(:habit) do
    %Habits.Habit{
      name: sequence(:name, &"Eat #{&1} Fish"),
      account: build(:account)
    }
  end

  def factory(:check_in) do
    %Habits.CheckIn{
      date: today_tuple,
      habit: build(:habit),
    }
  end

  defp today_tuple do
    date = Timex.DateTime.local
    {date.year, date.month, date.day}
  end
end
