defmodule Feder.Auth.Access do
  use Feder, :model
  use Feder, :routes

  alias Feder.Auth.Account

  @token_key :access_token
  @token_cookie %{
    name: "_#{@token_key}",
    opts: [
      sign: true,
      max_age: 365 * 60 * 24 * 60,
      same_site: "Lax"
    ]
  }

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

    account =
      if account = Account.get_by_email(email) do
        account
      else
        case Account.insert(%{email: email}) do
          {:ok, account} -> account
          {:error, _} -> nil
        end
      end

    insert(%{account_id: account.id})
  end

  @spec insert(map) :: %Access.Entity{}
  def insert(attrs) do
    %Access.Entity{}
    |> Access.Entity.changeset(attrs)
    |> Repo.insert()
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

  @spec token_key :: atom
  def token_key, do: @token_key

  @spec token_cookie :: %{
          name: String.t(),
          opts: Keyword.t()
        }
  def token_cookie, do: @token_cookie

  def token_cookie(key), do: token_cookie() |> Map.get(key)
end
