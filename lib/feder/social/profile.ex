defmodule Feder.Social.Profile do
  use Feder, :model

  alias __MODULE__.Entity

  @spec change(map) :: Ecto.Changeset.t()
  def change(attrs) do
    %Entity{} |> Entity.changeset(attrs)
  end

  @spec insert(map) :: {:ok, %Entity{}} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    change(attrs) |> Repo.insert()
  end

  @spec update(map) :: {:ok, %Entity{}} | {:error, Ecto.Changeset.t()}
  def update(attrs) do
    change(attrs) |> Repo.update()
  end

  @spec get_by_account_id(integer) :: nil | %Entity{}
  def get_by_account_id(account_id) do
    Repo.get_by(Entity, account_id: account_id)
  end
end
