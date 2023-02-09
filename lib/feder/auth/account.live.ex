defmodule Feder.Auth.Account.Live do
  use Feder, :live

  def render(assigns) do
    ~H"""
    <section class="space-y-4">
      <.heading>Manage Account</.heading>
      <.link href={~p"/access"} method="delete" class="block w-max">
        <.button>Sign out</.button>
      </.link>
    </section>
    """
  end
end
