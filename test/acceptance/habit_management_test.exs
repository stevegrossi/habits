defmodule Habits.HabitManagementTest do
  use HabitsWeb.AcceptanceCase

  setup _context do
    account = Factory.insert(:account,
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
    )
    [account: account]
  end

  test "Logging in, adding, editing, deleting, checking into and out of habits",
    %{session: session, account: account} do

    habit_name = "Run acceptance tests"

    session
    |> visit("/")
    |> click(link("Log In"))
    |> fill_in(text_field("Email"), with: account.email)
    |> fill_in(text_field("Password"), with: "password")
    |> click(button("Log In"))
    |> click(link("Add a Habit"))
    |> fill_in(text_field("Name"), with: habit_name)
    |> click(button("Add Habit"))
    |> refute_has(css(".CheckInButton--checkedIn"))
    |> click(button("Check In"))
    |> assert_has(css(".CheckInButton--checkedIn"))
    |> click(button("Check Out"))
    |> refute_has(css(".CheckInButton--checkedIn"))
    |> click(link(habit_name))
    |> click(link("× Delete"))
    |> refute_has(link(habit_name))
    |> click(link("Log Out"))
    |> assert_has(css(".lead"))
  end
end
