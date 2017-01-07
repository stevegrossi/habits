defmodule Habits.Repo.Migrations.CreateCheckIn do
  use Ecto.Migration

  def change do
    create table(:check_ins) do
      add :habit_id, references(:habits, on_delete: :delete_all), null: false
      add :date, :date, null: false

      timestamps()
    end
    create index(:check_ins, [:date])
    create index(:check_ins, [:habit_id, :date], unique: true)
  end
end
