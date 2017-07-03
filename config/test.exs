use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :habits, Habits.Endpoint,
  secret_key_base: "0000000000000000000000000000000000000000000000000000000000000000",
  http: [port: 4001],
  server: true

config :habits, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :habits, Habits.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "habits_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
