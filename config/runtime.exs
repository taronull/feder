import Config

if System.get_env("PHX_SERVER") do
  config :feder, Feder.Endpoint, server: true
end

if config_env() == :prod do
  config :feder, Feder.Storage,
    secret: System.get_env("STORAGE_SECRET") || raise("STORAGE_SECRET is missing.")

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

  # SSL is set from deployment.

  config :feder, Feder.Mailer,
    adapter: Swoosh.Adapters.AmazonSES,
    region: "us-east-2",
    access_key: "AKIAZM4E2LDLXL6X6DHF",
    secret: System.get_env("SES_SECRET") || raise("SES_SECRET is missing.")
end
