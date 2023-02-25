defmodule Feder.Auth.Access.Test do
  use Feder, :data_test

  alias Feder.Auth.Fixtures
  alias Feder.Auth.Access

  setup do
    %{access: Fixtures.access() |> Repo.preload(:account)}
  end

  describe "insert/1" do
    test "creates entity by existing account ID", %{access: access} do
      assert {:ok, %Access.Entity{}} = Access.insert(%{account_id: access.account_id})
      assert {:error, %Ecto.Changeset{}} = Access.insert(%{account_id: System.unique_integer()})
    end
  end

  describe "delete_by_token/1" do
    test "deletes entity by token", %{access: access} do
      assert Access.delete_by_token(access.token) == 1
      refute Repo.get(Access.Entity, access.id)
    end
  end

  describe "get_account_id_by_token/1" do
    test "gets the corresponding account ID with a token", %{access: access} do
      assert Access.get_account_id_by_token(access.token) == access.account_id
    end
  end
end
