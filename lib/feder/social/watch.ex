defmodule Feder.Social.Watch do
  use Feder, :model

  alias Feder.Social.Watch
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

  def get_profiles(profile_id) do
    Watch.Entity.query_profile_by_profile_id(profile_id) |> Repo.all()
  end
end
