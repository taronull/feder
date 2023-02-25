defmodule Feder.Auth.AccountID.Test do
  use Feder, :conn_test

  alias Feder.Auth.{Access, AccountID, Fixtures}

  setup do
    %{access: Fixtures.access()}
  end

  describe "access_account(conn, :session)" do
    setup %{access: access, conn: conn} do
      conn =
        conn
        |> put_session(Access.token_key(), access.token)
        |> Plug.run([{AccountID, []}])

      %{conn: conn}
    end

    test "assigns account ID", %{access: access, conn: conn} do
      assert conn.assigns.account_id == access.account_id
    end
  end

  describe "access_account(conn, :cookies)" do
    setup %{access: access, conn: conn} do
      %{name: name, opts: opts} = Access.token_cookie()

      conn =
        conn
        |> put_resp_cookie(name, access.token, opts)
        |> Plug.run([{AccountID, []}])

      %{conn: conn}
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
      encoded_token = Base.url_encode64(access.token)

      conn =
        put_in(conn.params["#{Access.token_key()}"], encoded_token)
        |> Plug.run([{AccountID, []}])

      %{conn: conn}
    end

    test "assigns account ID", %{access: access, conn: conn} do
      assert conn.assigns.account_id == access.account_id
    end

    test "stores token in session", %{access: access, conn: conn} do
      assert get_session(conn, Access.token_key()) == access.token
    end

    test "stores token in cookies", %{access: access, conn: conn} do
      assert conn.cookies[Access.token_cookie(:name)] == access.token
    end
  end

  describe "access_account(conn, :denied)" do
    setup do
      %{wrong_token: :crypto.strong_rand_bytes(32)}
    end

    test "assigns nil for no token", %{conn: conn} do
      conn = Plug.run(conn, [{AccountID, []}])

      refute conn.assigns.account_id
    end

    test "assigns nil for wrong session token", %{conn: conn, wrong_token: wrong_token} do
      conn =
        conn
        |> put_session(Access.token_key(), wrong_token)
        |> Plug.run([{AccountID, []}])

      refute conn.assigns.account_id
    end

    test "assigns nil for wrong token cookie", %{conn: conn, wrong_token: wrong_token} do
      %{name: name, opts: opts} = Access.token_cookie()

      conn =
        conn
        |> put_resp_cookie(name, wrong_token, opts)
        |> Plug.run([{AccountID, []}])

      refute conn.assigns.account_id
    end

    test "assigns nil for wrong token parameter", %{conn: conn, wrong_token: wrong_token} do
      encoded_wrong_token = Base.url_encode64(wrong_token)

      conn =
        put_in(conn.params["#{Access.token_key()}"], encoded_wrong_token)
        |> Plug.run([{AccountID, []}])

      refute conn.assigns.account_id
    end
  end
end
