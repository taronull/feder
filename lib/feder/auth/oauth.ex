defmodule Feder.Auth.OAuth do
  @google_certs_url "https://www.googleapis.com/oauth2/v3/certs"
  @issuer "https://accounts.google.com"

  @spec verify(String.t()) :: {:ok, payload :: map}
  def verify(token) do
    with {:ok, %{"kid" => key_id, "alg" => algorithm}} <- Joken.peek_header(token),
         {:ok, response} <- Finch.build(:get, @google_certs_url) |> Finch.request(Feder.Finch),
         %{"keys" => keys} <- Jason.decode!(response.body),
         key <- keys |> Enum.find(&(&1["kid"] == key_id)),
         signer <- Joken.Signer.create(algorithm, key),
         {:ok, payload} <- Joken.verify(token, signer),
         audience <- id(:google),
         true <- audience == payload["aud"] || audience == payload["azp"],
         true <- @issuer == payload["iss"] do
      {:ok, payload}
    end
  end

  def id(:google), do: Application.fetch_env!(:feder, :google_oauth_id)
end
