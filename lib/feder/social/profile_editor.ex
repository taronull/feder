defmodule Feder.Social.ProfileEditor do
  use Feder, :component

  alias Feder.Social.Profile

  def render(assigns) do
    ~H"""
    <div class="container">
      <.form
        for={@form}
        phx-target={@myself}
        phx-submit="edit_profile"
        phx-change="validate"
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
              <img src={image} alt="Current profile image" class="min-w-full min-h-full object-cover" />
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

  def update(%{id: account_id}, socket) do
    profile = Profile.get_by_account_id(account_id)
    form = Profile.cast(profile) |> to_form(as: "profile")

    {:ok,
     socket
     |> assign(:profile, profile)
     |> assign(:form, form)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png))}
  end

  def handle_event("validate", %{"profile" => profile_params}, socket) do
    form = Profile.cast(socket.assigns.profile, profile_params) |> to_form(as: "profile")

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("edit_profile", %{"profile" => profile_params}, socket) do
    with image <- consume_uploaded_entries(socket, :image, &upload/2) |> List.first(),
         profile_params <-
           if(image, do: Map.put(profile_params, "image", image.url), else: profile_params),
         {:ok, profile} <- Profile.update(socket.assigns.profile, profile_params) do
      form = Profile.cast(profile) |> to_form(as: "profile")

      {:noreply,
       socket
       |> assign(:profile, profile)
       |> assign(:form, form)
       |> put_flash(:ok, "Successfully updated")
       |> push_patch(to: ~p"/account")}
    end
  end

  defp upload(%{path: path}, _entry) do
    with {:ok, thumbnail} <- Image.thumbnail(path, 800),
         {:ok, file} <- Image.write(thumbnail, :memory, suffix: ".jpg"),
         {:ok, metadata} <- Feder.Storage.upload("/#{Ecto.UUID.generate()}", file) do
      {:ok, metadata}
    end
  end
end
