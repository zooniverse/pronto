# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pronto,
  ecto_repos: [Pronto.Repo]

# Configures the endpoint
config :pronto, Pronto.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wv/vgItAnLrYyk5LCr0XtpHOmut0krlK7y9btzdl1pPC1duYPUTvmv+95hXhs/XJ",
  render_errors: [view: Pronto.ErrorView, accepts: ~w(json)],
  pubsub: [name: Pronto.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["RS512"],
  issuer: "pan-deve",
  serializer: Pronto.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
