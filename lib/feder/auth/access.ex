defmodule Feder.Auth.Access do
  alias Feder.Repo
  alias Feder.Auth.Account
  alias __MODULE__

  @token_key :access_token
  @token_cookie [
    name: "_#{@token_key}",
    sign: true,
    max_age: 365 * 60 * 24 * 60,
    same_site: "Lax"
  ]

  @spec grant(String.t()) :: %Access.Entity{}
  def grant(email) do
    # TODO: Separate upsertion.
    with account <- Account.get_by_email(email) || Account.insert!(%{email: email}) do
      insert!(%{account_id: account.id})
    end
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

  @spec token_key() :: atom
  def token_key, do: @token_key

  @spec token_cookie() :: Keyword.t()
  def token_cookie, do: @token_cookie
end
