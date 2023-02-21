defmodule Feder.Storage do
  # TODO: Separate conn. `plug` macros conflict.
  use Feder, :conn
  use Tesla

  alias Tesla.Middleware

  def get(conn, %{"path" => path}) do
    with {:ok, %{status: 200, body: body}} <- download(path) do
      send_resp(conn, 200, body)
    end
  end

  defp download(path) do
    with {:ok, %{status: 200, body: body}} <- authorize() do
      [
        {Middleware.BaseUrl, "#{body["downloadUrl"]}/file/#{env(:bucket_name)}"},
        {Middleware.Headers, [{"Authorization", body["authorizationToken"]}]}
      ]
      |> Tesla.client()
      |> Tesla.get(Path.join(path))
    end
  end

  def upload(file, opts \\ []) do
    with {:ok, %{status: 200, body: body}} <- get_upload_url() do
      headers = [
        {"Authorization", body["authorizationToken"]},
        {"Content-Type", opts[:type] || "b2/x-auto"},
        {"Content-Length", byte_size(file) |> to_string()},
        {"X-Bz-File-Name", Ecto.UUID.generate()},
        {"X-Bz-Content-Sha1", :crypto.hash(:sha, file) |> Base.encode16()}
      ]

      [
        {Middleware.Headers, headers},
        Middleware.JSON
      ]
      |> Tesla.client()
      |> Tesla.post(body["uploadUrl"], file)
    end
  end

  defp get_upload_url do
    with {:ok, %{status: 200, body: body}} <- authorize() do
      [
        {Middleware.BaseUrl, body["apiUrl"] <> "/b2api/v2"},
        {Middleware.Headers, [{"Authorization", body["authorizationToken"]}]},
        Middleware.JSON
      ]
      |> Tesla.client()
      |> Tesla.post("b2_get_upload_url", %{bucketId: env(:bucket_id)})
    end
  end

  defp authorize do
    [
      {Middleware.BaseUrl, "https://api.backblazeb2.com/b2api/v2"},
      {Middleware.BasicAuth, username: env(:key_id), password: env(:key)},
      Middleware.JSON
    ]
    |> Tesla.client()
    |> Tesla.get("b2_authorize_account")
  end

  defp env, do: Application.get_env(:feder, __MODULE__)
  defp env(key), do: env() |> Keyword.get(key)
end
