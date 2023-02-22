defmodule Feder.Storage do
  # TODO: Separate conn. `plug` macros conflict.
  use Tesla

  alias Tesla.Middleware

  plug Middleware.BaseUrl, "https://storage.feder.is"
  plug Middleware.BearerAuth, token: env(:secret)

  def download(path) do
    get(path)
  end

  def upload(path, file) do
    put(path, file)
  end

  defp env, do: Application.get_env(:feder, __MODULE__)
  defp env(key), do: env() |> Keyword.get(key)
end
