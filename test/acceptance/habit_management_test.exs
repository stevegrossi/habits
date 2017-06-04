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
      |> assert_has(Query.css(".AppHeader"))
      |> click(Query.link("Log In"))
      |> fill_in(Query.text_field("Email"), with: account.email)
      |> fill_in(Query.text_field("Password"), with: "password")
      |> click(Query.button("Log In"))
      |> click(Query.link("Add a Habit"))
      |> fill_in(Query.text_field("Name"), with: habit_name)
      |> click(Query.button("Add Habit"))
      |> click(Query.link(habit_name))
      |> click(Query.link("× Delete"))

    assert has_no_css?(habits_page, ".Habit")
  end
end
