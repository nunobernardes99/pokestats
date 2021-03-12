defmodule Pokestats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pokestats.Repo,
      # Start the Telemetry supervisor
      PokestatsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pokestats.PubSub},
      # Start the Endpoint (http/https)
      PokestatsWeb.Endpoint
      # Start a worker by calling: Pokestats.Worker.start_link(arg)
      # {Pokestats.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pokestats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PokestatsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
