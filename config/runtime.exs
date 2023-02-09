import Config

if System.get_env("PHX_SERVER") do
  config :feder, Feder.Endpoint, server: true
end

if config_env() == :prod do
  config :feder, Feder.Repo,
    url: System.get_env("DATABASE_URL") || raise("DATABASE_URL is missing."),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: if(System.get_env("ECTO_IPV6"), do: [:inet6], else: [])

  config :feder, Feder.Endpoint,
    url: [
      host: System.get_env("PHX_HOST") || "feder.is",
      port: 443,
      scheme: "https"
    ],
    http: [
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: System.get_env("SECRET_KEY_BASE") || raise("SECRET_KEY_BASE is missing.")

  # SSL relies on Fly.io.

  config :feder, Feder.Mailer,
    adapter: Swoosh.Adapters.AmazonSES,
    region: "us-east-2",
    access_key: System.get_env("SES_ACCESS_KEY") || raise("SES_ACCESS_KEY is missing."),
    secret: System.get_env("SES_SECRET_KEY") || raise("SES_SECRET_KEY is missing.")
end
