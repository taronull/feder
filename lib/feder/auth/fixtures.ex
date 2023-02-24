defmodule Feder.Auth.Fixtures do
  alias Feder.Repo
  alias Feder.Auth.{Access, Account}

  def email, do: "account#{System.unique_integer([:positive, :monotonic])}@example.com"

  def account, do: Repo.insert!(%Account.Entity{email: email()})

  def access, do: Repo.insert!(%Access.Entity{account_id: account().id})
end
