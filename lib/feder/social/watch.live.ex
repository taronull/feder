defmodule Feder.Social.Watch.Live do
  use Feder, :live

  alias Feder.Social.Profile
  alias Feder.Social.Watch

  def render(assigns) do
    ~H"""
    <div class="space-y-16">
      <.heading>Share your code</.heading>
      <code><%= @code %></code>

      <.form for={@form} phx-submit="watch" phx-change="noop" class="space-y-4">
        <.heading>Enter a code</.heading>
        <.input name="code" placeholder="watch code" required />

        <.button phx-disable-with>
          Watch
        </.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    # TODO: Make it unique and secure.
    code = :rand.uniform(9999)
    Feder.Endpoint.subscribe("watch:#{code}")
    {:ok, socket |> assign(:code, code) |> assign(form: to_form(%{}, as: :watch))}
  end

  def handle_event("noop", _, socket), do: {:noreply, socket}

  def handle_event("watch", %{"code" => code}, socket) do
    watching_profile = Profile.get_by_account_id(socket.assigns.account_id)
    Feder.Endpoint.broadcast("watch:#{code}", "watch", watching_profile)
    {:noreply, socket |> redirect(to: ~p"/account")}
  end

  def handle_info(%{topic: "watch:" <> code, payload: watching_profile}, socket) do
    watched_profile = Profile.get_by_account_id(socket.assigns.account_id)

    {:ok, %Watch.Entity{}} =
      Watch.insert(%{watching_profile: watching_profile.id, watched_profile: watched_profile.id})

    Feder.Endpoint.unsubscribe("watch:#{code}")

    {:noreply,
     socket
     |> put_flash(:ok, "#{watching_profile.name} watches your profile")
     |> redirect(to: ~p"/account")}
  end

  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
