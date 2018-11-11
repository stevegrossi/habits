defmodule HabitsWeb.TokenAuthentication do
  @moduledoc """
  Authenticates an Account based on a token in the request header.

  Spec: https://tools.ietf.org/html/draft-hammer-http-token-auth-01
  """

  import Plug.Conn
  alias Habits.{Accounts, Auth}
  alias Habits.Accounts.Account

  def init(options), do: options

  def call(%Plug.Conn{assigns: %{current_account: %Account{}}} = conn, _opts) do
    # Allow manually setting current_account in tests
    conn
  end

  def call(conn, _opts) do
    case find_account(conn) do
      %Account{} = account -> assign(conn, :current_account, account)
      _ -> auth_error!(conn)
    end
  end

  defp find_account(conn) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token} <- parse_header(auth_header),
         {:ok, account_id} <- Auth.get_account_id_from_token(token),
         do: Accounts.get_account!(account_id)
  end

  defp parse_header(["Token token=" <> token]) do
    {:ok, String.replace(token, "\"", "")}
  end

  defp parse_header(_non_token_header), do: :error

  defp auth_error!(conn) do
    conn
    |> send_resp(:unauthorized, "")
    |> halt()
  end
end
