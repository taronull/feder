defmodule Feder.Auth.Account.Test do
  use Feder, :data_test

  alias Feder.Auth.Fixtures
  alias Feder.Auth.Account

  setup do
    %{account: Fixtures.account()}
  end

  describe "insert/1" do
    test "creates account with unique email", %{account: account} do
      assert {:ok, %Account.Entity{}} = Account.insert(%{email: Fixtures.email()})

      assert_raise Ecto.InvalidChangesetError, fn ->
        Account.insert(%{email: account.email})
      end
    end
  end

  describe "get_by_email/1" do
    test "gets account by email", %{account: account} do
      assert Account.get_by_email(account.email) == account
    end
  end
end
