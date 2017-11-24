# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :inskedular,
  ecto_repos: [Inskedular.Repo]

# Configures the endpoint
config :inskedular, InskedularWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HuFM9Cp4a5OxNT6Vo1+mOZSbiMTxoJAkYTsvQru9SxdgE5UHp+hHlp98v0VwV5Iz",
  render_errors: [view: InskedularWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Inskedular.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :commanded,
   event_store_adapter: Commanded.EventStore.Adapters.EventStore
config :commanded_ecto_projections,
  repo: Inskedular.Repo

config :vex,
  sources: [
    Inskedular.Support.Validators,
    Inskedular.Scheduling.Validators,
    Vex.Validators
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
