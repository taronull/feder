defmodule Feder.Core.Data.Case do
  @moduledoc """
  Defines a case for tests that require a data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Feder.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Feder.Core.Data.Case
    end
  end

  setup tags do
    Feder.Core.Data.Case.sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Feder.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  Transforms changeset errors into a map of messages.
  """
  def explain_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &complete_error_message/1)
  end

  defp complete_error_message({message, opts}) do
    Regex.replace(~r/%{(\w+)}/, message, fn _, key ->
      opts
      |> Keyword.get(String.to_existing_atom(key), key)
      |> to_string()
    end)
  end
end
