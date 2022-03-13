defmodule UrlshortnerApi.UrlShortner.Url do
  use Ecto.Schema
  import Ecto.Changeset

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
  end
end
