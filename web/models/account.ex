defmodule Habits.Account do
  @moduledoc """
  Data logic for the Account domain model, which represents a user of the app.
  """

  use Habits.Web, :model

  alias Habits.{Repo}

  schema "accounts" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :habits, Habits.Habit
    has_many :sessions, Habits.Session

    timestamps()
  end

  @doc """
  Builds a changeset based on the `account` struct and `params`.
  """
  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> encrypt_password_if_possible
    |> unique_constraint(:email)
  end

  @doc """
  Returns a list of CheckIns-counts by week, beginning with the first week for
  which there was a CheckIn
  """
  def check_in_data(_account) do
    query = """
    SELECT
      COUNT(check_ins.*)
    FROM generate_series((
      SELECT MIN(date_trunc('week', check_ins.date))
      FROM check_ins
    ), NOW(), '1 week'::interval) week
    LEFT OUTER JOIN check_ins
      ON date_trunc('week', check_ins.date) = week
    GROUP BY week
    ORDER BY week
    ;
    """
    %Postgrex.Result{rows: rows} = Ecto.Adapters.SQL.query!(Repo, query, [])
    Enum.map(rows, &List.first/1)
  end

  defp encrypt_password_if_possible(
    %Ecto.Changeset{changes: %{password: password}} = changeset) do

    changeset
    |> put_change(:encrypted_password, hashed_password(password))
  end
  defp encrypt_password_if_possible(%Ecto.Changeset{} = changeset) do
    changeset
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
