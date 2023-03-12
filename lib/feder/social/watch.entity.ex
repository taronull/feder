defmodule Feder.Social.Watch.Entity do
  use Feder, :entity

  import Ecto.Changeset

  @primary_key false

  schema "watch" do
    field :watching_profile_id_id, :id, primary_key: true
    field :watched_profile_id_id, :id, primary_key: true
  end

  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:watching_profile_id_id, :watched_profile_id_id])
    |> validate_required([:watching_profile_id_id, :watched_profile_id_id])
    |> unique_constraint([:watching_profile_id_id, :watched_profile_id_id], name: :watch_pkey)
  end

  def query_by_profile_id(profile_id) do
    from w in Entity,
      where:
        w.watched_profile_id_id == ^profile_id or
          w.watching_profile_id_id == ^profile_id
  end

  def query_profile_by_profile_id(profile_id) do
    from w in query_by_profile_id(profile_id),
      join: profile in assoc(w, :profile)
  end
end
