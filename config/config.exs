# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pokestats,
  ecto_repos: [Pokestats.Repo]

# Configures the endpoint
config :pokestats, PokestatsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QoiG99Zvboe1nNXDRbm8HJSEVuFIkfK1u62VsEdB//Iqx1zBubfPKJ+C7KGEP2Iv",
  render_errors: [view: PokestatsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pokestats.PubSub,
  live_view: [signing_salt: "bOwwA69M"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
