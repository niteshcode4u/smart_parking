import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :smart_parking, SmartParking.Repo,
  username: "postgres",
  password: "postgres",
  database: "smart_parking_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :smart_parking, SmartParkingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6fAKUv0cImxTUN2zT7Y/5TGsLJ8bB/n2n2uR16daBzm37R8CB++spsnQmPA5jDnp",
  server: false

# In test we don't send emails.
config :smart_parking, SmartParking.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
