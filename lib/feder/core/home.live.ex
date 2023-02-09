defmodule Feder.Core.Home.Live do
  # No layout.
  use Phoenix.LiveView
  use Feder, :html
  use Feder, :components

  def render(assigns) do
    ~H"""
    <div class={[
      "mx-auto p-8 w-[32rem] max-w-full h-screen",
      "grid content-center gap-8"
    ]}>
      <.flash messages={@flash} />
      <article class="space-y-4">
        <.heading class={["text-2xl md:text-3xl"]}>
          <img class="w-12" src="/images/symbol.svg" />
          <span class="font-medium">Feder</span> 
          <span class="font-normal">—</span> 
          <span class="font-normal italic">Social Journal</span>
        </.heading>
        <p>Collect and share the difference you make.</p>
      </article>
      <menu class="space-y-4">
        <%= if @account_id do %>
          <li>
            <.link href={~p"/account"}><%= @account_id %></.link>
          </li>
        <% else %>
          <li>
            <.google_oauth />
          </li>
          <li>
            <.button 
              onclick="document.querySelector('#continue-with-email-modal').showModal()"
            >
              Continue with Email
            </.button>
            <.modal id="continue-with-email-modal">
              <.form for={:account} phx-submit="mail_access" class="space-y-4">
                <.input name="email" placeholder="Your email" />
                <.button phx-disable-with>
                  Send Link 
                </.button>
              </.form>
            </.modal>
          </li>
        <% end %>
      </menu>
    </div>
    """
  end

  def handle_event("mail_access", %{"email" => email}, socket) do
    Feder.Auth.mail_access(email)

    {:noreply, put_flash(socket, :info, "Check your email")}
  end
end
