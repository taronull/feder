defmodule Feder.Repo do
  use Ecto.Repo,
    otp_app: :feder,
    adapter: Ecto.Adapters.SQLite3
end
