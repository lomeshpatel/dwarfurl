defmodule UrlshortnerApi.SlugGeneratorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlshortnerApi.SlugGenerator` context.
  """

  @doc """
  Generate a slug.
  """
  def slug_fixture(attrs \\ %{}) do
    {:ok, slug} =
      attrs
      |> Enum.into(%{
        is_used: true,
        slug: "some slug"
      })
      |> UrlshortnerApi.SlugGenerator.create_slug()

    slug
  end

  def slug_fixture_bulk() do
    UrlshortnerApi.SlugGenerator.create_slugs_bulk()
  end
end
