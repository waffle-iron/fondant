use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure database
config :fondant_service, Fondant.Service.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "fondant_service_dev",
    hostname: "localhost",
    pool_size: 10
