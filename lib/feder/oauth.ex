defmodule Feder.OAuth do
  @certs "https://www.googleapis.com/oauth2/v3/certs"

  @spec verify(binary) :: {:ok, Joken.claims()} | {:error, term}
  def verify(token) do
    with {:ok, signer} <- create_signer(token) do
      Joken.verify(token, signer)
    end
  end

  defp create_signer(token) do
    with {:ok, %{"kid" => kid, "alg" => alg}} <- Joken.peek_header(token),
         {:ok, response} <- Tesla.get(@certs) do
      key =
        response.body
        |> Jason.decode!()
        |> Map.get("keys")
        |> Enum.find(fn key -> key["kid"] == kid end)

      {:ok, Joken.Signer.create(alg, key)}
    end
  end

  def id, do: env(:id)

  defp env, do: Application.get_env(:feder, __MODULE__)
  defp env(key), do: env() |> Keyword.get(key)
end
