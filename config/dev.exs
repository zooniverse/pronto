use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :pronto, Pronto.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :pronto, Pronto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || System.get_env("USER") || "postgres",
  password: System.get_env("POSTGRES_PASS") || nil,
  database: System.get_env("POSTGRES_DB")   || "pronto_dev",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool_size: 10

config :guardian, Guardian,
 secret_key: fn ->
   JOSE.JWK.from_pem_file("config/doorkeeper-jwt-development.pub")
 end
