defmodule Feder.Auth.Components do
  use Feder, :html

  alias Feder.OAuth

  def google_oauth(assigns) do
    ~H"""
    <button id="google_oauth" class="block" phx-update="ignore">
      <div
        id="g_id_onload"
        data-client_id={OAuth.id()}
        data-login_uri={url(~p"/access")}
        data-auto_prompt="false"
      >
      </div>
      <div class="g_id_signin" data-type="standard" data-text="continue_with"></div>
    </button>
    """
  end
end
