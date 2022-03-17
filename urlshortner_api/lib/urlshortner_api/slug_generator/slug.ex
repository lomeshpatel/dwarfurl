defmodule UrlshortnerApi.SlugGenerator.Slug do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:slug, :string, []}
  schema "slugs" do
    field :is_used, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(slug, attrs) do
    slug
    |> cast(attrs, [:slug, :is_used])
    |> validate_required([:slug, :is_used])
  end
end
