defmodule UrlshortnerApi.UrlShortnerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlshortnerApi.UrlShortner` context.
  """

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        original_url: "some original_url",
        slug: "some slug"
      })
      |> UrlshortnerApi.UrlShortner.create_url()

    url
  end
end
