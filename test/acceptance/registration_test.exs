defmodule Habits.RegistrationTest do
  use Habits.AcceptanceCase #, async: true

  test "Registering", %{session: session} do
    session
    |> visit("/register")
    |> assert_has(Query.css(".AppHeader"))
    |> fill_in(Query.text_field("Email"), with: "nubbins@test.cat")
    |> fill_in(Query.text_field("Password"), with: "iamacat")
    |> click(Query.button("Register"))
    |> find(Query.css(".Button", [text: "Add a Habit"]))
  end

  # This test should not pass, but if it does
  # it confirms everything but react is working

  test "React is broken", %{session: session} do
    page =
      session
      |> visit("/register")

    assert has_text?(page, "Loading...")
  end
end
