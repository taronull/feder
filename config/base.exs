# Configuration is compiled before the application code.

import Config

config :feder,
  ecto_repos: [Feder.Repo]

config :feder, Feder.OAuth,
  id: "445767527784-ff0vsts09jg62lqpbfak3vri3vo5qagf.apps.googleusercontent.com"

config :feder, Feder.Storage,
  key: "K005H09LU8UztzmXJw5PuNPc0v/AdjQ",
  key_id: "005a9f84557c67c0000000005",
  bucket_id: "dae9af78545575078c66071c",
  bucket_name: "feder-dev"

config :feder, Feder.Endpoint,
  url: [host: "localhost"],
  live_view: [signing_salt: "/+KjqkN4"],
  pubsub_server: Feder.PubSub,
  render_errors: [
    formats: [html: Feder.Core.Error, json: Feder.Core.Error],
    layout: false
  ]

config :tesla, adapter: {Tesla.Adapter.Finch, name: Feder.Finch}

config :esbuild,
  version: "0.14.41",
  default: [
    args: ~w(
      js/app.js 
      --bundle 
      --target=es2017 
      --outdir=../priv/static/assets 
      --external:/fonts/* 
      --external:/images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.1.8",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :phoenix, :json_library, Jason

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# This must be the last so it overrides the values above.
import_config "#{config_env()}.exs"
