defmodule Habits.Auth.Session do
  @moduledoc """
  The schema for Sessions, which represent an individual’s authorization to
  perform actions on behalf of an Account.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Habits.Accounts.Account

  @timestamps_opts type: :utc_datetime, usec: false
  schema "sessions" do
    field(:token, :string)
    field(:location, :string)
    belongs_to(:account, Account)

    timestamps()
  end

  @default_location "Earth"
  def default_location, do: @default_location

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:account_id, :location])
    |> validate_required([:account_id, :location])
    |> put_change(:token, SecureRandom.urlsafe_base64())
    |> validate_required([:account_id, :token])
  end
end
