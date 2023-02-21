defmodule Feder.Social.Profile.Live do
  use Feder, :live

  alias Feder.Social.Profile.Entity

  def mount(_params, _session, socket) do
    socket
    |> assign(changeset: to_form(Entity.changeset(%Entity{}, %{})))
    |> allow_upload(:image, accept: ~w(.jpg .jpeg .png))
    |> then(&{:ok, &1})
  end

  def render(assigns) do
    ~H"""
    <.form
      :let={form}
      for={@changeset}
      phx-submit="create_profile"
      phx-change="noop"
      class="space-y-4"
    >
      <.heading>Create Your Profile</.heading>

      <label
        for={@uploads.image.ref}
        phx-drop-target={@uploads.image.ref}
        class={[
          theme(:invert),
          tickle(),
          "block h-24 aspect-square rounded-full overflow-clip",
          "grid place-items-center"
        ]}
      >
        <.live_file_input upload={@uploads.image} class="hidden" />
        <%= if entry = List.first(@uploads.image.entries) do %>
          <.live_img_preview entry={entry} />
        <% else %>
          <Heroicons.photo class="h-12" />
        <% end %>
      </label>

      <.input field={{form, :name}} placeholder="Profile name" required />

      <.button phx-disable-with>
        Create Profile
      </.button>
    </.form>

    <img src="/storage/4bdc0cc0-bb6e-40fe-bd5a-2bb8de0d7d33" alt="" />
    """
  end

  def handle_event("create_profile", _params, socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      with {:ok, thumbnail} <- Image.thumbnail(path, 800),
           {:ok, image} <- Image.write(thumbnail, :memory, suffix: ".jpg") do
        Feder.Storage.upload(image, type: "image/jpeg")
      end
    end)

    {:noreply, socket}
  end

  # `live_file_input` requires a `change` handler.
  def handle_event("noop", _, socket), do: {:noreply, socket}
end
