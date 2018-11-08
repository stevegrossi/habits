defmodule Habits.Repo.Migrations.CreateHabit do
  use Ecto.Migration

  def change do
    create table(:habits) do
      add(:name, :string, null: false)
      add(:account_id, references(:accounts), null: false)

      timestamps()
    end

    create(index(:habits, [:account_id]))
  end
end
