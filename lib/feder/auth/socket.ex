defmodule Feder.Auth.Socket do
  import Phoenix.Component

  alias Feder.Auth.{Access, Account}

  @doc """
  Defines an `:on_mount` option callback for `live_session/3`.
  Logs the account in on `Phoenix.LiveView.Socket` layer
  """
  def on_mount(:default, _params, session, socket) do
    {:cont, assign_new(socket, Account.id_key(), fn -> access_account(session) end)}
  end

  defp access_account(session) do
    with token when is_binary(token) <- session["#{Access.token_key()}"] do
      Access.get_account_id_by_token(token)
    end
  end
end
