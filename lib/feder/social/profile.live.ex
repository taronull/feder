defmodule Feder.Social.Profile.Live do
  use Feder, :live

  alias Feder.Social.Profile.Entity

  def mount(params, _session, socket) do
    socket
    |> assign(email: params["email"])
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

      <code><%= @email %></code>

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
          <.live_img_preview class="min-w-full min-h-full object-cover" entry={entry} />
        <% else %>
          <Heroicons.photo class="h-8" />
        <% end %>
      </label>

      <.input field={{form, :name}} placeholder="Profile name" required />

      <.button phx-disable-with>
        Create Profile
      </.button>
    </.form>
    """
  end

  # `live_file_input` requires a `change` handler.
  def handle_event("noop", _, socket), do: {:noreply, socket}

  def handle_event("create_profile", %{"name" => name}, socket) do
    with image <- consume_uploaded_entries(socket, :image, &upload/2) |> List.first(%{}),
         {:ok, _} <- Feder.Auth.register(socket.assigns.email, name, Map.get(image, :url)),
         {:ok, _} <- Feder.Auth.mail(socket.assigns.email) do
      socket
      |> put_flash(:info, "Check your email")
      |> redirect(to: "/")
      |> then(&{:noreply, &1})
    end
  end

  defp upload(%{path: path}, _entry) do
    with {:ok, thumbnail} <- Image.thumbnail(path, 800),
         {:ok, file} <- Image.write(thumbnail, :memory, suffix: ".jpg") do
      Feder.Storage.upload("/profile/image/#{Ecto.UUID.generate()}", file)
      |> dbg()
    end
  end
end
