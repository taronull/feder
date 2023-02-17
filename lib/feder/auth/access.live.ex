defmodule Feder.Auth.Access.Live do
  use Feder, :live

  def render(assigns) do
    ~H"""
    <.form for={:account} phx-submit="mail_access" class="space-y-4">
      <.heading>Continue with Email</.heading>

      <.input name="email" placeholder="Your email" />

      <.button phx-disable-with>
        Send Access Link
      </.button>
    </.form>
    """
  end

  def handle_event("mail_access", %{"email" => email}, socket) do
    Feder.Auth.mail_access(email)

    {:noreply, put_flash(socket, :info, "Check your email")}
  end
end
