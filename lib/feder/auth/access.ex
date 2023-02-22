defmodule Feder.Auth.Access do
  use Feder, :routes

  alias Feder.Repo
  alias Feder.Auth.Account
  alias __MODULE__

  @doc """
  Sends an email with an access token to `account`.
  """
  @spec mail(String.t()) :: {:ok, term} | {:error, term}
  def mail(email) do
    with access <- Access.grant(email) do
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

  @spec grant(String.t()) :: %Access.Entity{}
  def grant(email) do
    # TODO: Separate upsertion.
    account = Account.get_by_email(email) || Account.insert!(%{email: email})

    insert!(%{account_id: account.id})
  end

  @spec insert!(map) :: %Access.Entity{}
  def insert!(attrs) do
    %Access.Entity{}
    |> Access.Entity.changeset(attrs)
    |> Repo.insert!()
  end

  @spec delete_by_token(binary) :: count :: integer
  def delete_by_token(token) do
    token
    |> Access.Entity.query_by_token()
    |> Repo.delete_all()
    |> then(fn {count, _return} -> count end)
  end

  @spec get_account_id_by_token(String.t()) :: integer | nil
  def get_account_id_by_token(token) do
    token
    |> Access.Entity.query_account_id_by_token()
    |> Repo.one()
  end

  @spec token_key :: :access_token
  def token_key, do: :access_token

  @spec token_cookie :: %{
          name: String.t(),
          opts: Keyword.t()
        }
  def token_cookie do
    %{
      name: "_#{token_key()}",
      opts: [
        sign: true,
        max_age: 365 * 60 * 24 * 60,
        same_site: "Lax"
      ]
    }
  end
end
