defmodule Feder.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Feder.Telemetry,
      Feder.Repo,
      {Phoenix.PubSub, name: Feder.PubSub},
      {Finch, name: Feder.HTTP},
      Feder.Endpoint
      # Start a worker by calling: Feder.Worker.start_link(arg)
      # {Feder.Worker, arg}
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: Feder.Supervisor
    )
  end

  # Apply config changes when application code changes.
  @impl Application
  def config_change(changed, _new, removed) do
    Feder.Endpoint.config_change(changed, removed)
    :ok
  end
end
