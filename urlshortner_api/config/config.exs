# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

cache_size = Application.get_env(:urlshortner_api, UrlshortnerApi.SlugCache)[:cache_size]

config :urlshortner_api,
  ecto_repos: [UrlshortnerApi.Repo],
  children: [
    # Start the Ecto repository
    UrlshortnerApi.Repo,
    # Start the Telemetry supervisor
    UrlshortnerApiWeb.Telemetry,
    # Start the PubSub system
    {Phoenix.PubSub, name: UrlshortnerApi.PubSub},
    # Start the Endpoint (http/https)
    UrlshortnerApiWeb.Endpoint,
    # Start a worker by calling: UrlshortnerApi.Worker.start_link(arg)
    # {UrlshortnerApi.Worker, arg}
    {UrlshortnerApi.SlugCache, [cache_size, UrlshortnerApi.SlugCache]}
  ]

# Configures the endpoint
config :urlshortner_api, UrlshortnerApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: UrlshortnerApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: UrlshortnerApi.PubSub,
  live_view: [signing_salt: "4zavjDoh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
