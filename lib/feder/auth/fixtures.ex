defmodule Feder.Auth.Fixtures do
  alias Feder.Auth.{Access, Account}
  def email, do: "account#{System.unique_integer([:positive, :monotonic])}@example.com"

  def account, do: Account.insert!(%{email: email()})

  def access, do: Access.insert!(%{account_id: account().id})
end
