defmodule Habits.Repo.Migrations.AddLocationToSession do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :location, :string, null: false
    end
  end
end
