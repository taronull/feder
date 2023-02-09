import Config

config :feder, Feder.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  # MIX_TEST_PARTITION for test partitioning in CI environment.
  database: "feder_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :feder, Feder.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bN8jPPz/FSsdtHDBNTZg/H9227z6KiAphQtV9X0tMUfBoKBdFond0JivhdaimG4i",
  # Don't run a server during test.
  server: false

# In test we don't send emails.
config :feder, Feder.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
