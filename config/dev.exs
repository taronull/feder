import Config

config :feder, Feder.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "feder_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :feder, Feder.Endpoint,
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "VhBEAzK+prlA44JnSG2nLNRf4LFRNc+7lVieR4Vc9KeWYLhAiml6W9pyvPnnSdhF",
  # Run external watchers to your application. 
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :feder, Feder.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/.*live.*(ex)$"
    ]
  ]

# Find the emails in your browser, at "/dev/mailbox".
config :feder, Feder.Mailer, adapter: Swoosh.Adapters.Local

# Enable dev routes for dashboard and mailbox
config :feder, dev_routes: true

# Set a higher stacktrace during development.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation.
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Do not include metadata nor timestamps in development logs.
config :logger, :console, format: "[$level] $message\n"
