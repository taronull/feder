defmodule Feder.Auth.AccountID do
  @moduledoc """
  __Plug__: Discovers access token in

    1. Session for current session
    2. Cookies for revisit log-in
      -> stores in session
    3. Parameters for new URL sign-in
      -> stores in cookies and session 

  Then assigns the account ID.
  """

  import Plug.Conn

  alias Feder.Auth.{Access, Account}

  @behaviour Plug

  @impl Plug
  def init(opts \\ []) do
    opts
  end

  @impl Plug
  def call(conn, _opts) do
    access_account(conn)
  end

  defp access_account(conn, source \\ :session)

  defp access_account(conn, :session) do
    with token when is_binary(token) <- get_session(conn, Access.token_key()),
         id when is_integer(id) <- Access.get_account_id_by_token(token) do
      assign(conn, Account.id_key(), id)
    else
      nil -> access_account(conn, :cookies)
    end
  end

  defp access_account(conn, :cookies) do
    with cookie_name <- Access.token_cookie(:name),
         conn <- fetch_cookies(conn, signed: [cookie_name]),
         token when is_binary(token) <- conn.cookies[cookie_name],
         id when is_integer(id) <- Access.get_account_id_by_token(token) do
      conn
      |> put_session(:live_socket_id, Base.url_encode64(token))
      |> put_session(Access.token_key(), token)
      |> assign(Account.id_key(), id)
    else
      nil -> access_account(conn, :params)
    end
  end

  defp access_account(conn, :params) do
    with encoded_token when is_binary(encoded_token) <- conn.params["#{Access.token_key()}"],
         {:ok, token} when is_binary(token) <- Base.url_decode64(encoded_token),
         id when is_integer(id) <- Access.get_account_id_by_token(token),
         cookie_name <- Access.token_cookie(:name),
         cookie_opts <- Access.token_cookie(:opts) do
      conn
      |> put_resp_cookie(cookie_name, token, cookie_opts)
      |> put_session(:live_socket_id, encoded_token)
      |> put_session(Access.token_key(), token)
      |> assign(Account.id_key(), id)
    else
      result when result in [nil, :error] -> access_account(conn, :denied)
    end
  end

  defp access_account(conn, :denied), do: assign(conn, Account.id_key(), nil)
end
