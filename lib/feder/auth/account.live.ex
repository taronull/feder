defmodule Feder.Auth.Account.Live do
  use Feder, :live

  alias Feder.Social.WatchEditor
  alias Feder.Auth.Account

  def mount(_params, _session, socket) do
    account = Account.get_by_id(socket.assigns.account_id)

    {:ok, assign(socket, :account, account)}
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-16">
      <section class="space-y-4">
        <.heading>Watch Profiles</.heading>
        <.live_component module={WatchEditor} id={@account_id} />
      </section>

      <section class="space-y-4">
        <.heading>Edit Your Profile</.heading>
        <.live_component module={ProfileEditor} id={@account_id} />
      </section>

      <section class="space-y-4">
        <.heading>Manage Your Account</.heading>
        <pre><%= @account.email %></pre>
        <.link href={~p"/access"} method="delete" class="block w-max">
          <.button>Sign out</.button>
        </.link>
      </section>
    </div>
    """
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
