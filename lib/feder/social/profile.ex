defmodule Feder.Social.Profile do
  use Feder, :model

  @spec insert(map) :: {:ok, %Profile.Entity{}} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    %Profile.Entity{}
    |> Profile.Entity.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_account_id(account_id) do
    Repo.get_by(Profile.Entity, account_id: account_id)
  end
end
