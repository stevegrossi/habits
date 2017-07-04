defmodule Habits.RegistrationTest do
  use Habits.AcceptanceCase #, async: true

  test "Registering", %{session: session} do
    session
    |> visit("/register")
    |> assert_has(css(".AppHeader"))
    |> fill_in(text_field("Email"), with: "nubbins@test.cat")
    |> fill_in(text_field("Password"), with: "iamacat")
    |> click(button("Register"))
    |> find(css(".Button", [text: "Add a Habit"]))
  end
end
