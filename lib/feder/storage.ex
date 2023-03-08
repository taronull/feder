defmodule Feder.Storage do
  use Tesla

  alias Tesla.Middleware

  plug Middleware.BaseUrl, env(:url)
  plug Middleware.BearerAuth, token: env(:secret)

  def upload(path, file) do
    put(path, file) |> dbg()
  end

  defp env, do: Application.get_env(:feder, __MODULE__)

  defp env(key), do: env() |> Keyword.get(key)
end
