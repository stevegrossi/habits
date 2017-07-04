defmodule Habits.HabitManagementTest do
  use Habits.AcceptanceCase

  setup _context do
    account = Factory.insert(:account,
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
    )
    [account: account]
  end

  test "Logging in, adding, editing, and deleting habits",
    %{session: session, account: account} do

    habit_name = "Run acceptance tests"
    habits_page =
      session
      |> visit("/")
      |> assert_has(css(".AppHeader"))
      |> click(link("Log In"))
      |> fill_in(text_field("Email"), with: account.email)
      |> fill_in(text_field("Password"), with: "password")
      |> click(button("Log In"))
      |> click(link("Add a Habit"))
      |> fill_in(text_field("Name"), with: habit_name)
      |> click(button("Add Habit"))
      |> click(link(habit_name))
      |> click(link("× Delete"))

    assert has_no_css?(habits_page, ".Habit")
  end
end
