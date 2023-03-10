defmodule Feder.Social.Watch.Entity do
  use Feder, :entity

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

  def query_by_profile_id(profile_id) do
    from w in Entity,
      where:
        w.watched_profile == ^profile_id or
          w.watching_profile == ^profile_id
  end

  def query_profile_by_profile_id(profile_id) do
    from w in query_by_profile_id(profile_id),
      join: profile in assoc(w, :profile)
  end
end
