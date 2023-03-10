defmodule Feder.Social.WatchList do
  use Feder, :component

  alias Feder.Social.Profile
  alias Feder.Social.Watch

  def render(assigns) do
    ~H"""
    <p>list</p>
    """
  end

  def update(%{id: account_id}, socket) do
    profile = Profile.get_by_account_id(account_id)
    profiles = Watch.get_profiles(profile.id)
    {:ok, assign(socket, :profiles, profiles)}
  end
end
