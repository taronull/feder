defmodule Feder.HTTP do
  def request(method, url, headers \\ [], body \\ nil, opts \\ []) do
    Finch.build(method, url, headers, body, opts) |> Finch.request(__MODULE__)
  end
end
