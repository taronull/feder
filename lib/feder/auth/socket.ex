defmodule Feder.Auth.Socket do
  use Feder, :socket

  alias Feder.Auth.{Access, Account}

  @doc """
  Defines an `:on_mount` option callback for `live_session/3`.
  Logs the account in on `Phoenix.LiveView.Socket` layer.
  """

  def on_mount(:redirect_account, _params, session, socket) do
    socket = access_account(session, socket)

    unless socket.assigns[Account.id_key()] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/account")}
    end
  end

  def on_mount(:require_account, _params, session, socket) do
    socket = access_account(session, socket)

    if socket.assigns[Account.id_key()] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/")}
    end
  end

  defp access_account(session, socket) do
    if token = session["#{Access.token_key()}"] do
      assign_new(socket, Account.id_key(), fn -> Access.get_account_id_by_token(token) end)
    else
      assign_new(socket, Account.id_key(), fn -> nil end)
    end
  end
end
