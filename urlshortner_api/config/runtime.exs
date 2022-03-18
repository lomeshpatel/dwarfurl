import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :urlshortner_api, UrlshortnerApiWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :urlshortner_api, UrlshortnerApi.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :urlshortner_api, UrlshortnerApiWeb.Endpoint,
    url: [host: host, port: 443],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :urlshortner_api, UrlshortnerApiWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Application specific configurations
  # Configuration dictates how the SlugGenerator would operate
  config :urlshortner_api, UrlshortnerApi.SlugGenerator,
    # What should the default length of a generated slug
    default_slug_length: String.to_integer(System.get_env("DEFAULT_SLUG_LENGTH") || "8"),
    # What should the maximum length of a generated slug
    max_slug_length: String.to_integer(System.get_env("MAX_SLUG_LENGTH") || "16"),
    # How many slugs should be generated everytime they strat to run low
    default_slugs_batch_size:
      String.to_integer(System.get_env("DEFAULT_SLUG_BATCH_SIZE") || "100"),
    # What is the maximum number of slugs that should be generated everytime they start to run low
    max_slugs_batch_size: String.to_integer(System.get_env("MAX_SLUG_BATCH_SIZE") || "1000")

  # Configuration dictates how the SlugCache would operate
  config :urlshortner_api, UrlshortnerApi.SlugCache,
    # How many slugs should be cached
    cache_size: String.to_integer(System.get_env("SLUG_CACHE_SIZE") || "100"),
    # What should be the maximum number of slugs that should be cached
    max_size: String.to_integer(System.get_env("MAX_SLUG_CACHE_SIZE") || "1000"),
    # At what point should we refill the cache to ensure that we never really run out of slugs in the cache
    refill_threshold: String.to_integer(System.get_env("SLUG_CACHE_REFILL_THRESHOLD") || "75")
end
