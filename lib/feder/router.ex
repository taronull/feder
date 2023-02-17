defmodule Feder.Router do
  use Phoenix.Router, helpers: false

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Feder.Core.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Feder.Auth.AccountID
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Feder do
    pipe_through :browser

    live_session :auth, on_mount: Feder.Auth.Socket do
      live "/", Core.Home.Live
      live "/access", Auth.Access.Live
      live "/account", Auth.Account.Live
    end
  end

  scope "/", Feder do
    pipe_through :api

    post "/access", Auth.Conn, :sign_in
    delete "/access", Auth.Conn, :sign_out
  end

  # Enables LiveDashboard and Swoosh mailbox preview in development.
  if Application.compile_env(:feder, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Feder.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
