defmodule Feder.Storage do
  # TODO: Separate conn. `plug` macros conflict.
  use Tesla

  alias Tesla.Middleware

  # TODO: Use custom domain.
  plug Middleware.BaseUrl, "https://storage.feder.workers.dev"
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
