defmodule Feder.Repo do
  use Ecto.Repo,
    otp_app: :feder,
    adapter: Ecto.Adapters.Postgres
end
