defmodule Habits.Repo do
  use Ecto.Repo, otp_app: :habits

  import Ecto.Query, only: [from: 2]

  def count(queryable) do
    Habits.Repo.one(from x in queryable, select: count(x.id))
  end

  def exists?(queryable) do
    count(queryable) > 0
  end
end
