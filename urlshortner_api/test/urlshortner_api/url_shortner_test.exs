defmodule UrlshortnerApi.UrlShortnerTest do
  use UrlshortnerApi.DataCase

  alias UrlshortnerApi.UrlShortner

  describe "urls" do
    alias UrlshortnerApi.UrlShortner.Url
    alias UrlshortnerApi.SlugCache
    alias UrlshortnerApi.SlugGenerator

    import UrlshortnerApi.UrlShortnerFixtures

    setup do
      slug_cache =
        start_supervised!({SlugCache, [SlugCache.get_env(:cache_size), UrlshortnerApi.SlugCache]})

      %{slug_cache: slug_cache}
    end

    @invalid_attrs %{original_url: nil, slug: nil}

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert UrlShortner.get_url!(url.slug) == url
    end

    test "create_url/1 with valid data creates a url" do
      valid_attrs = %{original_url: "some original_url", slug: "some slug"}

      assert {:ok, %Url{} = url} = UrlShortner.create_url(valid_attrs)
      assert url.original_url == "some original_url"
      assert url.slug == "some slug"
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UrlShortner.create_url(@invalid_attrs)
    end

    test "create_url/1 with no data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UrlShortner.create_url()
    end

    test "create_url/1 with no slug creates a url after fetching a slug from the SlugCache", %{
      slug_cache: slug_cache
    } do
      slug = List.first(:sys.get_state(slug_cache))
      attrs = %{original_url: "https://www.looneytunes.com/eeeeeeeeeeeeehhhhhhh/whats/up/doc"}

      assert {:ok, %Url{} = url} = UrlShortner.create_url(attrs)
      assert url.original_url == attrs.original_url
      assert url.slug == slug
    end

    test "create_url/1 with slug less than minimum length returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UrlShortner.create_url(%{@invalid_attrs | slug: "a"})
    end

    test "create_url/1 with slug greater than maximum length returns error changeset" do
      long_slug =
        1..SlugGenerator.get_env(:max_slug_length)
        |> Enum.reduce("ab", fn _, acc -> acc <> "cd" end)

      assert {:error, %Ecto.Changeset{}} =
               UrlShortner.create_url(%{@invalid_attrs | slug: long_slug})
    end

    test("delete_url/1 deletes the url") do
      url = url_fixture()
      assert {:ok, %Url{}} = UrlShortner.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> UrlShortner.get_url!(url.slug) end
    end
  end
end
