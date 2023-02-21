defmodule Feder.Auth.Conn do
  use Feder, :conn

  alias Feder.Auth.Access
  alias Feder.OAuth

  @doc """
  Signs account in with JWT.
  """
  def sign_in(conn, params) do
    with conn <- fetch_cookies(conn),
         true <- conn.cookies["g_csrf_token"] == params["g_csrf_token"],
         {:ok, %{"email" => email}} <- OAuth.verify(params["credential"]),
         %{token: token} <- Access.grant(email),
         cookie_name <- Access.token_cookie() |> Keyword.get(:name),
         cookie_opts <- Access.token_cookie() |> Keyword.drop([:name]) do
      conn
      |> put_resp_cookie(cookie_name, token, cookie_opts)
      |> redirect(to: ~p"/")
    end
  end

  @doc """
  Signs the account out. Clears all session data.
  """
  def sign_out(conn, _params) do
    with conn <- fetch_session(conn),
         token <- get_session(conn, Access.token_key()),
         socket <- get_session(conn, :live_socket_id) do
      Access.delete_by_token(token)
      Feder.Endpoint.broadcast(socket, "disconnect", %{})

      conn
      |> configure_session(renew: true)
      |> clear_session()
      |> delete_resp_cookie(Access.token_cookie()[:name])
      |> redirect(to: ~p"/")
    end
  end
end
