use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :inskedular, InskedularWeb.Endpoint,
  http: [port: 4001],
  server: false

config :inskedular, :environment, :test

# Print only warnings and errors during test
config :logger, level: :debug

config :ex_unit,
  capture_log: true

# Configure your database
config :inskedular, Inskedular.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "inskedular_readstore_test",
  hostname: "localhost",
  pool_size: 1

# Configure the event store database
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "inskedular_eventstore_test",
  hostname: "localhost",
  pool_size: 1
