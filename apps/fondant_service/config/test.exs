use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure database
config :fondant_service, Fondant.Service.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "fondant_service_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
