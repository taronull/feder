defmodule Feder.Auth.Access.Live do
  use Feder, :live

  alias Feder.Auth
  alias Feder.Auth.{Access, Account}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :account?, nil)}
  end

  def render(assigns) do
    ~H"""
    <.form
      for={%{}}
      as={:account}
      phx-change="check_account"
      phx-submit={if @account?, do: "mail_access", else: "create_profile"}
      class="space-y-4"
    >
      <.heading>Continue with Email</.heading>

      <.input name="email" type="email" placeholder="Your email" />

      <.button phx-disable-with>
        <%= if @account?, do: "Send Access Link", else: "Create New Account" %>
      </.button>
    </.form>
    """
  end

  def handle_event("check_account", %{"email" => email}, socket) do
    {:noreply, assign(socket, :account?, !!Account.get_by_email(email))}
  end

  def handle_event("create_profile", %{"email" => email}, socket) do
    socket
    |> redirect(to: "/profile?email=#{email}")
    |> then(&{:noreply, &1})
  end

  def handle_event("mail_access", %{"email" => email}, socket) do
    with {:ok, _} <- Auth.mail(email) do
      socket
      |> put_flash(:info, "Check your email")
      |> redirect(to: "/")
      |> then(&{:noreply, &1})
    end
  end
end
