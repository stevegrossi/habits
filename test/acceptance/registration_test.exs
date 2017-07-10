defmodule Habits.RegistrationTest do
  use Habits.AcceptanceCase

  test "Registering", %{session: session} do
    session
    |> visit("/register")
    |> fill_in(text_field("Email"), with: "nubbins@test.cat")
    |> fill_in(text_field("Password"), with: "iamacat")
    |> click(button("Register"))
    |> assert_has(css(".Button", text: "Add a Habit"))
  end
end
