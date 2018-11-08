defmodule Habits.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:email, :string, null: false)
      add(:encrypted_password, :string, null: false)

      timestamps()
    end

    create(index(:accounts, [:email], unique: true))
  end
end
