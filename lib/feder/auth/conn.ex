defmodule Feder.Auth.Conn do
  use Feder, :conn

  alias Feder.Auth
  alias Feder.Auth.{Access, Account}
  alias Feder.OAuth

  @doc """
  Signs account in with JWT.
  """
  def sign_in(conn, params) do
    with {:ok, conn} <- fetch_cookies(conn) |> check_csrf_token(params),
         {:ok, payload} <- OAuth.verify(params["credential"]),
         {:ok, account} <- ensure_account(payload),
         {:ok, access} <- Access.insert(%{account_id: account.id}) do
      %{name: name, opts: opts} = Access.token_cookie()

      conn
      |> put_resp_cookie(name, access.token, opts)
      |> redirect(to: ~p"/")
    end
  end

  defp ensure_account(%{"email" => email, "given_name" => name, "picture" => image}) do
    case Account.get_by_email(email) do
      %Account.Entity{} = account -> {:ok, account}
      _ -> Auth.register(email, name, image)
    end
  end

  @doc """
  Signs the account out. Clears all session data.
  """
  def sign_out(conn, _params) do
    conn
    |> fetch_session()
    |> invalidate_token()
    |> sever_live_socket()
    |> configure_session(renew: true)
    |> clear_session()
    |> delete_resp_cookie(Access.token_cookie().name)
    |> redirect(to: ~p"/")
  end

  defp check_csrf_token(conn, params) do
    if conn.cookies["g_csrf_token"] == params["g_csrf_token"] do
      {:ok, conn}
    else
      {:error, :invalid_token}
    end
  end

  defp invalidate_token(conn) do
    token = get_session(conn, Access.token_key())
    Access.delete_by_token(token)

    conn
  end

  defp sever_live_socket(conn) do
    socket_id = get_session(conn, :live_socket_id)
    Feder.Endpoint.broadcast(socket_id, "disconnect", %{})

    conn
  end
end
