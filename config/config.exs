# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :jogo_da_velha, JogoDaVelhaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "npu3FJJwyMlQzdvH8JpvTIj6mjKOeJVuk0uq5V3uX0afGyowlzLHD7I/HK5XfLsW",
  render_errors: [view: JogoDaVelhaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub: [name: JogoDaVelha.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "vx05wdh4"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
