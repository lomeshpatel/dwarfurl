defmodule UrlshortnerApi.Repo do
  use Ecto.Repo,
    otp_app: :urlshortner_api,
    adapter: Ecto.Adapters.Postgres
end
