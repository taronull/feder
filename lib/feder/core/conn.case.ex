defmodule Feder.Core.Conn.Case do
  @moduledoc """
  Defines a case for tests that require a connection.
  """

  use ExUnit.CaseTemplate

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

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
