defmodule Feder.Social.ProfileImage do
  use Feder, :component
  use Feder, :components

  alias Feder.Social.Profile

  def update(assigns, socket) do
    profile = Profile.get_by_account_id(assigns.account_id)

    {:ok, assign(socket, :profile, profile)}
  end

  def render(assigns) do
    ~H"""
    <figure class={[
      tickle(),
      "border border-current p-px h-6 w-6 rounded-full overflow-clip",
      "grid place-items-center"
    ]}>
      <%= if @profile.image do %>
        <img
          class="rounded-full w-5 aspect-square object-cover"
          src={@profile.image}
          alt={@profile.name}
        />
      <% else %>
        <Heroicons.user class="h-4 stroke-1" />
      <% end %>
    </figure>
    """
  end
end
