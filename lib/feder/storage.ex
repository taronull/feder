defmodule Feder.Storage do
  use Feder, :conn

  @auth_url "https://api.backblazeb2.com/b2api/v2/b2_authorize_account"

  def download(conn, %{"path" => path}) do
    with %{"authorizationToken" => token, "downloadUrl" => download_url} <- authorize(),
         env <- Application.get_env(:feder, __MODULE__),
         url <- Path.join([download_url, "file", env[:bucket_name], path]),
         auth <- {"Authorization", token},
         {:ok, response} <- Finch.build(:get, url, [auth]) |> Finch.request(Feder.Finch) |> dbg() do
      send_resp(conn, 200, response.body)
    end
  end

  def upload(path, opts \\ []) do
    with %{"authorizationToken" => token, "uploadUrl" => url} <- get_upload_url(),
         file <- File.read!(path),
         headers <- [
           {"Authorization", token},
           {"Content-Type", opts[:type] || "b2/x-auto"},
           {"Content-Length", to_string(opts[:size] || File.stat!(path).size)},
           {"X-Bz-File-Name", URI.encode(opts[:name] || Ecto.UUID.generate())},
           {"X-Bz-Content-Sha1", :crypto.hash(:sha, file) |> Base.encode16()}
         ],
         {:ok, response} <- Finch.build(:post, url, headers, file) |> Finch.request(Feder.Finch) do
      Jason.decode!(response.body)
    end
  end

  defp get_upload_url() do
    with %{"authorizationToken" => token, "apiUrl" => api_url} <- authorize(),
         url <- Path.join([api_url, "b2api", "v2", "b2_get_upload_url"]),
         auth <- {"Authorization", token},
         env <- Application.get_env(:feder, __MODULE__),
         body <- Jason.encode!(%{bucketId: env[:bucket_id]}),
         {:ok, response} <- Finch.build(:post, url, [auth], body) |> Finch.request(Feder.Finch) do
      Jason.decode!(response.body)
    end
  end

  defp authorize() do
    with env <- Application.get_env(:feder, __MODULE__),
         auth <- {"Authorization", "Basic #{Base.encode64("#{env[:key_id]}:#{env[:key]}")}"},
         {:ok, response} <- Finch.build(:get, @auth_url, [auth]) |> Finch.request(Feder.Finch) do
      Jason.decode!(response.body)
    end
  end
end
