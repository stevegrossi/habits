defmodule Habits.AccountManagementTest do
  use HabitsWeb.AcceptanceCase

  setup _context do
    account =
      Factory.insert(:account,
        encrypted_password: Comeonin.Bcrypt.hashpwsalt("password")
      )

    habit = Factory.insert(:habit, account: account)
    Factory.insert(:check_in, habit: habit)
    Factory.insert(:session, account: account, location: "Area 51")

    [account: account]
  end

  test "My Account page and active sessions",
       %{session: session, account: account} do
    session
    |> visit("/")
    |> click(link("Log In"))
    |> fill_in(text_field("Email"), with: account.email)
    |> fill_in(text_field("Password"), with: "password")
    |> click(button("Log In"))
    |> click(link("Me"))
    |> assert_has(css("h2", text: account.email))
    # Total Check-Ins
    |> assert_has(css(".fs-xl", text: "1"))
    |> assert_has(css(".AchievementList"))
    |> click(link("Active Sessions"))
    |> take_screenshot
    |> assert_has(css(".ActionList-item", text: "Earth (Current)"))
    |> find(css(".ActionList-item", text: "Area 51"))
    |> click(link("×"))

    session
    |> refute_has(css(".ActionList-item", text: "Area 51"))
    |> click(link("Log Out"))
    |> assert_has(css(".lead"))
  end
end
