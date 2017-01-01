defmodule Habits.Session do
  use Habits.Web, :model

  schema "sessions" do
    field :token, :string
    belongs_to :account, Habits.Account

    timestamps
  end

  @required_fields ~w(account_id token)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end
end
