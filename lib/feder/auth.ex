defmodule Feder.Auth do
  alias Ecto.Multi
  alias Feder.Repo
  alias __MODULE__.{Account}
  alias Feder.Social.Profile

  @spec register(String.t(), String.t(), String.t() | nil) ::
          {:ok, %Account.Entity{}}
          | {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
  def register(email, name, image \\ nil) do
    # This is the only guarantee of a proflie for every account.
    Multi.new()
    |> Multi.insert(:account, %Account.Entity{email: email})
    |> Multi.insert(:profile, fn %{account: account} ->
      %Profile.Entity{account_id: account.id, name: name, image: image}
    end)
    |> Repo.transaction()
    |> then(fn {:ok, %{account: account}} -> {:ok, account} end)
  end
end
