defmodule Feder.Social.ProfileEditor do
  use Feder, :component

  alias Feder.Social.Profile

  def update(assigns, socket) do
    profile = Profile.get_by_account_id(assigns.account_id)

    socket
    |> assign(:form, to_form(Profile.Entity.changeset(profile, %{})))
    |> allow_upload(:image, accept: ~w(.jpg .jpeg .png))
    |> then(&{:ok, &1})
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <.form
        :let={form}
        for={@changeset}
        phx-submit="edit_profile"
        phx-change="noop"
        phx-target={@myself}
        class="space-y-4"
      >
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
          <.live_file_input upload={@uploads.image || @profile.image} class="hidden" />
          <%= if entry = List.first(@uploads.image.entries) do %>
            <.live_img_preview class="min-w-full min-h-full object-cover" entry={entry} />
          <% else %>
            <Heroicons.photo class="h-8 stroke-1" />
          <% end %>
        </label>

        <.input field={{form, :name}} placeholder="Profile name" required />

        <.button phx-disable-with>
          Edit Profile
        </.button>
      </.form>
    </div>
    """
  end

  # `live_file_input` requires a `change` handler.
  def handle_event("noop", _, socket), do: {:noreply, socket}

  def handle_event("edit_profile", params, socket) do
    dbg(params)
    {:ok, socket}
    # with image <- consume_uploaded_entries(socket, :image, &upload/2) |> List.first(%{}),
    #      {:ok, _} <- Profile.update() do
    #   socket
    #   |> then(&{:noreply, &1})
    # end
  end

  defp upload(%{path: path}, _entry) do
    with {:ok, thumbnail} <- Image.thumbnail(path, 800),
         {:ok, file} <- Image.write(thumbnail, :memory, suffix: ".jpg") do
      Feder.Storage.upload("/profile/image/#{Ecto.UUID.generate()}", file)
    end
  end
end
