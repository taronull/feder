defmodule Feder.Auth.Access.Live do
  use Feder, :live

  alias Feder.Auth.Access

  def render(assigns) do
    ~H"""
    <.form for={%{}} as={:account} phx-submit="mail_access" class="space-y-4">
      <.heading>Continue with Email</.heading>

      <.input name="email" type="email" placeholder="Your email" />

      <.button phx-disable-with>
        Send Access Link
      </.button>
    </.form>
    """
  end

  def handle_event("mail_access", %{"email" => email}, socket) do
    Access.mail(email)

    socket
    |> put_flash(:info, "Check your email")
    |> redirect(to: "/")
    |> then(&{:noreply, &1})
  end
end
