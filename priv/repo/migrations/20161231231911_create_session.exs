defmodule Habits.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :token, :string, null: false
      add :account_id, references(:accounts, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:sessions, [:account_id])
    create index(:sessions, [:token])
  end
end
