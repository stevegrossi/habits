defmodule Habits.Session do
  @moduledoc """
  Data logic for the user’s various sessions
  (e.g. desktop, mobile) when using the app.
  """

  use Habits.Web, :model
  use Timex.Ecto.Timestamps

  schema "sessions" do
    field :token, :string
    belongs_to :account, Habits.Account

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:account_id])
    |> put_change(:token, SecureRandom.urlsafe_base64())
    |> validate_required([:account_id, :token])
  end
end
