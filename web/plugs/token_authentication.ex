defmodule Habits.TokenAuthentication do
  @moduledoc """
  Authenticates an Account based on a token in the request header.

  Spec: https://tools.ietf.org/html/draft-hammer-http-token-auth-01
  """

  import Plug.Conn
  alias Habits.{Repo, Account, Session}
  import Ecto.Query, only: [from: 2]

  def init(options), do: options

  def call(%Plug.Conn{assigns: %{current_account: %Account{}}} = conn, _opts) do
    conn # Allow manually setting current_account in tests
  end
  def call(conn, _opts) do
    case find_account(conn) do
      {:ok, account} -> assign(conn, :current_account, account)
      _otherwise  -> auth_error!(conn)
    end
  end

  defp find_account(conn) do
    with auth_header = get_req_header(conn, "authorization"),
         {:ok, token}   <- parse_header(auth_header),
         {:ok, session} <- find_session_by_token(token),
    do:  find_account_by_session(session)
  end

  defp parse_header(["Token token=" <> token]) do
    {:ok, String.replace(token, "\"", "")}
  end
  defp parse_header(_non_token_header), do: :error

  defp find_session_by_token(token) do
    case Repo.one(from s in Session, where: s.token == ^token) do
      nil     -> :error
      session -> {:ok, session}
    end
  end

  defp find_account_by_session(session) do
    case Repo.get(Account, session.account_id) do
      nil  -> :error
      account -> {:ok, account}
    end
  end

  defp auth_error!(conn) do
    conn
    |> send_resp(:unauthorized, "")
    |> halt()
  end
end
