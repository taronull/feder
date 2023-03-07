defmodule Feder.Social.ProfileEditor do
  use Feder, :component

  alias Feder.Social.Profile

  def update(assigns, socket) do
    profile = Profile.get_by_account_id(assigns.id)
    form = Profile.cast(profile) |> to_form(as: "profile")

    {:ok,
     socket
     |> assign(:profile, profile)
     |> assign(:form, form)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png))}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <.form
        for={@form}
        phx-target={@myself}
        phx-submit="edit_profile"
        phx-change="noop"
        class="space-y-4"
        multipart
      >
        <label
          for={@uploads.image.ref}
          phx-drop-target={@uploads.image.ref}
          class={[
            theme(),
            tickle(),
            "block border border-current rounded-full h-24 w-24 overflow-clip",
            "grid place-items-center"
          ]}
        >
          <.live_file_input upload={@uploads.image} class="hidden" />
          <%= cond do %>
            <% entry = List.first(@uploads.image.entries) -> %>
              <.live_img_preview entry={entry} class="min-w-full min-h-full object-cover" />
            <% image = @profile.image -> %>
              <img src={image} alt="Current profile image" />
            <% true -> %>
              <Heroicons.photo class="h-8 stroke-1" />
          <% end %>
        </label>

        <.input field={@form[:name]} placeholder="Profile name" required />

        <.button phx-disable-with>
          Edit Profile
        </.button>
      </.form>
    </div>
    """
  end

  def handle_event("noop", _, socket), do: {:noreply, socket}

  def handle_event("edit_profile", %{"profile" => profile}, socket) do
    with image <- consume_uploaded_entries(socket, :image, &upload/2) |> List.first(),
         profile <- if(image, do: Map.put(profile, "image", image.url), else: profile),
         {:ok, _} <- Profile.update(socket.assigns.profile, profile) do
      {:noreply,
       socket
       |> put_flash(:ok, "Successfully updated")
       |> push_patch(to: ~p"/account")}
    end
  end

  defp upload(%{path: path}, _entry) do
    with {:ok, thumbnail} <- Image.thumbnail(path, 800),
         {:ok, file} <- Image.write(thumbnail, :memory, suffix: ".jpg") do
      Feder.Storage.upload("/profile/image/#{Ecto.UUID.generate()}", file)
    end
  end
end
