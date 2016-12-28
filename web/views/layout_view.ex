defmodule Habits.LayoutView do
  use Habits.Web, :view

  def logged_in?(conn) do
    !!conn.assigns[:current_account]
  end
end
