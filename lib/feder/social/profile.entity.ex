defmodule Feder.Social.Profile.Entity do
  use Feder, :entity

  alias Feder.Social

  schema "profile" do
    field :image, :string
    field :name, :string

    belongs_to :account, Feder.Auth.Account.Entity, foreign_key: :account_id

    many_to_many :watching_profile_id, __MODULE__,
      join_through: Social.Watch.Entity,
      join_keys: [watching_profile_id: :id, watched_profile_id: :id]

    many_to_many :watched_profile_id, __MODULE__,
      join_through: Social.Watch.Entity,
      join_keys: [watched_profile_id: :id, watching_profile_id: :id]

    timestamps()
  end

  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :image])
    |> validate_required([:name])
    |> validate_length(:name, max: 255)
  end
end
