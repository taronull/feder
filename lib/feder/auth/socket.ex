defmodule Feder.Auth.Socket do
  import Phoenix.Component

  alias Feder.Auth.{Access, Account}

  @doc """
  Defines an `:on_mount` option callback for `live_session/3`.
  Logs the account in on `Phoenix.LiveView.Socket` layer
  """
  def on_mount(:default, _params, session, socket) do
    token = session["#{Access.token_key()}"]
    id = token && Access.get_account_id_by_token(token)

    socket
    |> assign_new(Account.id_key(), fn -> id end)
    |> then(&{:cont, &1})
  end
end
