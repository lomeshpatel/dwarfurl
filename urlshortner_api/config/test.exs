import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :urlshortner_api, UrlshortnerApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "urlshortner_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :urlshortner_api,
  children: [
    # Start the Ecto repository
    UrlshortnerApi.Repo,
    # Start the Telemetry supervisor
    UrlshortnerApiWeb.Telemetry,
    # Start the PubSub system
    {Phoenix.PubSub, name: UrlshortnerApi.PubSub},
    # Start the Endpoint (http/https)
    UrlshortnerApiWeb.Endpoint
    # Start a worker by calling: UrlshortnerApi.Worker.start_link(arg)
    # {UrlshortnerApi.Worker, arg}
  ]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :urlshortner_api, UrlshortnerApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WpoNFw5mKGrRQ1z2pvo2ACkeJUKTX4yCXe6DmtYgM5amk1yPvTCZhteJ0vQJkxu4",
  server: false

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :urlshortner_api, UrlshortnerApi.SlugGenerator,
  min_slug_length: 4,
  default_slug_length: 8,
  max_slug_length: 16,
  default_slugs_batch_size: 10,
  max_slugs_batch_size: 1000

config :urlshortner_api, UrlshortnerApi.SlugCache,
  cache_size: 10,
  max_size: 100,
  refill_threshold: 7
