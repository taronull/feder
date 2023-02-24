defmodule Feder.Journal.Live do
  use Feder, :live

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    {:ok, assign(socket, :profile_name, params["profile_name"])}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <p><%= @profile_name %></p>
    """
  end
end
