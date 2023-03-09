defmodule Feder.Social.Watch.Entity do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  schema "watch" do
    field :watching_profile, :id, primary_key: true
    field :watched_profile, :id, primary_key: true
  end

  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:watching_profile, :watched_profile])
    |> validate_required([:watching_profile, :watched_profile])
    |> unique_constraint([:watching_profile, :watched_profile], name: :watch_pkey)
  end
end
