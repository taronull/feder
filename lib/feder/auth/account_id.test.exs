defmodule Feder.Auth.AccountID.Test do
  use Feder, :conn_test

  alias Feder.Auth.{Access, AccountID, Fixtures}

  setup %{conn: conn} do
    with conn <- %{conn | secret_key_base: @endpoint.config(:secret_key_base)},
         conn <-
           Plug.run(conn, [
             {Plug.Session, @endpoint.session()},
             {Plug.Parsers, @endpoint.parsers()},
             &Plug.Conn.fetch_session(&1)
           ]) do
      %{access: Fixtures.access(), conn: conn}
    end
  end

  describe "access_account(conn, :session)" do
    setup %{access: access, conn: conn} do
      with conn <- put_session(conn, Access.token_key(), access.token),
           conn <- Plug.run(conn, [{AccountID, []}]) do
        %{conn: conn}
      end
    end

    test "assigns account ID", %{access: access, conn: conn} do
      assert conn.assigns.account_id == access.account_id
    end
  end

  describe "access_account(conn, :cookies)" do
    setup %{access: access, conn: conn} do
      with cookie_name <- Access.token_cookie() |> Keyword.get(:name),
           cookie_opts <- Access.token_cookie() |> Keyword.drop([:name]),
           conn <- put_resp_cookie(conn, cookie_name, access.token, cookie_opts),
           conn <- Plug.run(conn, [{AccountID, []}]) do
        %{conn: conn}
      end
    end

    test "assigns account ID", %{access: access, conn: conn} do
      assert conn.assigns.account_id == access.account_id
    end

    test "stores token in session", %{access: access, conn: conn} do
      assert get_session(conn, Access.token_key()) == access.token
    end
  end

  describe "access_account(conn, :params)" do
    setup %{access: access, conn: conn} do
      with encoded_token <- Base.url_encode64(access.token),
           conn <- put_in(conn.params["#{Access.token_key()}"], encoded_token),
           conn <- Plug.run(conn, [{AccountID, []}]) do
        %{conn: conn}
      end
    end

    test "assigns account ID", %{access: access, conn: conn} do
      assert conn.assigns.account_id == access.account_id
    end

    test "stores token in session", %{access: access, conn: conn} do
      assert get_session(conn, Access.token_key()) == access.token
    end

    test "stores token in cookies", %{access: access, conn: conn} do
      assert conn.cookies[Access.token_cookie()[:name]] == access.token
    end
  end

  describe "access_account(conn, :denied)" do
    setup do
      %{wrong_token: :crypto.strong_rand_bytes(32)}
    end

    test "assigns nil for no token", %{conn: conn} do
      with conn <- Plug.run(conn, [{AccountID, []}]) do
        refute conn.assigns.account_id
      end
    end

    test "assigns nil for wrong session token", %{conn: conn, wrong_token: wrong_token} do
      with conn <- put_session(conn, Access.token_key(), wrong_token),
           conn <- Plug.run(conn, [{AccountID, []}]) do
        refute conn.assigns.account_id
      end
    end

    test "assigns nil for wrong token cookie", %{conn: conn, wrong_token: wrong_token} do
      with cookie_name <- Access.token_cookie() |> Keyword.get(:name),
           cookie_opts <- Access.token_cookie() |> Keyword.drop([:name]),
           conn <- put_resp_cookie(conn, cookie_name, wrong_token, cookie_opts),
           conn <- Plug.run(conn, [{AccountID, []}]) do
        refute conn.assigns.account_id
      end
    end

    test "assigns nil for wrong token parameter", %{conn: conn, wrong_token: wrong_token} do
      with encoded_wrong_token <- Base.url_encode64(wrong_token),
           conn <- put_in(conn.params["#{Access.token_key()}"], encoded_wrong_token),
           conn <- Plug.run(conn, [{AccountID, []}]) do
        refute conn.assigns.account_id
      end
    end
  end
end
