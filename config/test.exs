import Config

config :strabo, ecto_repos: [Strabo.Test.Repo]

config :strabo, Strabo.Test.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  types: Strabo.PostgrexTypes

# Print only warnings and errors during test
config :logger, level: :warning
