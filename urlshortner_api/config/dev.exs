import Config

# Configure your database
config :urlshortner_api, UrlshortnerApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "urlshortner_api_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :urlshortner_api, UrlshortnerApiWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: false,
  secret_key_base: "1jVyQUkKXPyCVfqLYwH2xo9jUB4HTXudZAJmLKqDrze9hrkvjzmwJwPknNddk7z3",
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :urlshortner_api, UrlshortnerApi.SlugGenerator,
  default_slug_length: 8,
  max_slug_length: 16,
  default_slugs_batch_size: 100,
  max_slugs_batch_size: 1000

config :urlshortner_api, UrlshortnerApi.SlugCache,
  cache_size: 100,
  max_size: 1000,
  refill_threshold: 75
