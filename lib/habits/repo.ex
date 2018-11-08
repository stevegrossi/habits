defmodule Habits.Repo do
  use Ecto.Repo, otp_app: :habits, adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [from: 2]

  def count(queryable) do
    Habits.Repo.one(from(x in queryable, select: count(x.id)))
  end
end
