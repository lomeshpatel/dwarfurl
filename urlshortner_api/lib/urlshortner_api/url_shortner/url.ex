defmodule UrlshortnerApi.UrlShortner.Url do
  use Ecto.Schema
  import Ecto.Changeset

  alias UrlshortnerApi.SlugGenerator

  @derive {Phoenix.Param, key: :slug}
  @primary_key {:slug, :string, []}
  schema "urls" do
    field :original_url, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original_url, :slug])
    |> validate_required([:original_url, :slug])
    |> validate_length(
      :slug,
      min: SlugGenerator.get_env(:min_slug_length),
      max: SlugGenerator.get_env(:max_slug_length)
    )
  end
end
