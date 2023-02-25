defmodule Feder.Core.Conn.Case do
  @moduledoc """
  Defines a case for tests that require a connection.
  """

  use ExUnit.CaseTemplate

  @endpoint Feder.Endpoint

  using do
    quote do
      use Feder, :routes

      import Plug.Conn
      import Phoenix.ConnTest
      import Feder.Core.Conn.Case
    end
  end

  setup tags do
    Feder.Core.Data.Case.sandbox(tags)

    conn =
      Phoenix.ConnTest.build_conn()
      |> Map.put(:secret_key_base, @endpoint.config(:secret_key_base))
      |> Plug.run(plugs())

    {:ok, conn: conn}
  end

  defp plugs do
    [
      {Plug.Session, @endpoint.session()},
      {Plug.Parsers, @endpoint.parsers()},
      &Plug.Conn.fetch_session(&1)
    ]
  end
end
