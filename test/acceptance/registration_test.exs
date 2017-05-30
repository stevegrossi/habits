defmodule Habits.RegistrationTest do
  use Habits.AcceptanceCase

  test "it works", meta do
    navigate_to("http://localhost:4001/register")

    find_element(:id, "registration-email")
    |> fill_field("nubbins@test.cat")

    find_element(:id, "registration-password")
    |> fill_field("iamacat")

    find_element(:class, "Button")
    |> click

    find_element(:link_text, "Add a Habit")
  end

end
