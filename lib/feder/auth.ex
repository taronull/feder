defmodule Feder.Auth do
  use Feder, :routes

  alias Ecto.Multi
  alias Feder.Repo
  alias __MODULE__.{Access, Account}
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

  @doc """
  Sends an email with an access token to `account`.
  """
  @spec mail(String.t()) :: {:ok, term} | {:error, term}
  def mail(email) do
    with %{id: id} <- Account.get_by_email(email),
         {:ok, access} <- Access.insert(%{account_id: id}) do
      Feder.Mailer.post(email, %{
        title: "Sign in with your email",
        body: """
        Sign in with your account by visiting the URL below:
        #{url(~p"/?#{Access.token_key()}=") <> Base.url_encode64(access.token)}
        If you didn't request for this, please ignore this.
        """
      })
    end
  end
end
