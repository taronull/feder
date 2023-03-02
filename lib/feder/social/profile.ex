defmodule Feder.Social.Profile do
  use Feder, :model

  alias __MODULE__.Entity

  @spec cast(%Entity{}, map) :: Ecto.Changeset.t()
  def cast(%Entity{} = entity, attrs \\ %{}) do
    Entity.changeset(entity, attrs)
  end

  @spec insert(map) :: {:ok, %Entity{}} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    cast(%Entity{}, attrs) |> Repo.insert()
  end

  @spec update(%Entity{}, map) :: {:ok, %Entity{}} | {:error, Ecto.Changeset.t()}
  def update(%Entity{} = entity, attrs) do
    cast(entity, attrs) |> Repo.update()
  end

  @spec get_by_account_id(integer) :: nil | %Entity{}
  def get_by_account_id(account_id) do
    Repo.get_by(Entity, account_id: account_id)
  end
end
