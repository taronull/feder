defmodule Feder.Endpoint do
  use Phoenix.Endpoint, otp_app: :feder

  @session [
    store: :cookie,
    key: "_session",
    signing_salt: "HaqXj/Jg",
    same_site: "Lax"
  ]
  @parsers [
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  ]
  @static_paths ~w(assets fonts images favicons robots.txt site.webmanifest browserconfig.xml)

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session]]

  # Serves "priv/static"  at "/". 
  plug Plug.Static,
    at: "/",
    from: :feder,
    gzip: true,
    only: @static_paths

  # Configure :code_reloader.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :feder
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers, @parsers
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session
  plug Feder.Router

  def session, do: @session

  def parsers, do: @parsers

  def static_paths, do: @static_paths
end
