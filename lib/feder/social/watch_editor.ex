defmodule Feder.Social.WatchEditor do
  use Feder, :component

  def render(assigns) do
    ~H"""
    <p>watch</p>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
