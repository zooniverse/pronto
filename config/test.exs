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
  username: System.get_env("POSTGRES_USER") || System.get_env("USER") || "postgres",
  password: System.get_env("POSTGRES_PASS") || nil,
  database: System.get_env("POSTGRES_DB")   || "pronto_test",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :guardian, Guardian,
 secret_key: fn ->
   JOSE.JWK.from_pem_file("config/doorkeeper-jwt-test.pem")
 end
