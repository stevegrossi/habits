defmodule Habits.Factory do
  use ExMachina.Ecto, repo: Habits.Repo

  def account_factory do
    %Habits.Accounts.Account{
      email: sequence(:email, &"email-#{&1}@example.com"),
      encrypted_password: "password"
    }
  end

  def session_factory do
    %Habits.Auth.Session{
      token: sequence(:name, &"token-#{&1}"),
      location: "Earth",
      account: build(:account)
    }
  end

  def habit_factory do
    %Habits.Habits.Habit{
      name: sequence(:name, &"Eat #{&1} Fish"),
      account: build(:account)
    }
  end

  def check_in_factory do
    %Habits.Habits.CheckIn{
      date: Habits.Date.today(),
      habit: build(:habit)
    }
  end
end
