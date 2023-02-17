defmodule Feder.Social.List.Entity do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  schema "list" do
    field :listing_profile, :id, primary_key: true
    field :listed_profile, :id, primary_key: true
  end

  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:listing_profile, :listed_profile])
    |> validate_required([:listing_profile, :listed_profile])
    |> unique_constraint([:listing_profile, :listed_profile], name: :list_pkey)
  end
end
