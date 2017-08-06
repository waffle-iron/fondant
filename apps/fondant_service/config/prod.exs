use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

# Configure database
config :fondant_service, Fondant.Service.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool_size: 20
