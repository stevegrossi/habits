defmodule Habits.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Habits.{Repo, Accounts.Account}

  def registration_permitted? do
    if Repo.exists?(Account) do
      {:error, "An account already exists. Please log in."}
    else
      :ok
    end
  end
end
