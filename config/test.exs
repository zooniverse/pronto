use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pronto, Pronto.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pronto, Pronto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("USER") || "postgres",
  password: nil,
  database: "pronto_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
