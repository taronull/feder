defmodule Feder.Social.Profile.Entity do
  use Feder, :entity

  alias Feder.Social

  schema "profile" do
    field :image, :string
    field :name, :string

    belongs_to :account, Feder.Auth.Account.Entity, foreign_key: :account_id

    many_to_many :listing_profile, __MODULE__,
      join_through: Social.List.Entity,
      join_keys: [listing_profile: :id, listed_profile: :id]

    many_to_many :listed_profile, __MODULE__,
      join_through: Social.List.Entity,
      join_keys: [listed_profile: :id, listing_profile: :id]

    timestamps()
  end

  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :image])
    |> validate_required([:name])
    |> validate_length(:name, max: 255)
  end
end
