defmodule Feder.Auth.Fixtures do
  alias Feder.Repo
  alias Feder.Auth.{Access, Account}

  def email do
    number = System.unique_integer([:positive, :monotonic])
    "account#{number}@example.com"
  end

  def account do
    Repo.insert!(%Account.Entity{email: email()})
  end

  def access do
    Repo.insert!(%Access.Entity{
      account_id: account().id,
      token: :crypto.strong_rand_bytes(32)
    })
  end
end
