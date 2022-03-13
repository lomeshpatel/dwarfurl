defmodule UrlshortnerApi.UrlShortnerTest do
  use UrlshortnerApi.DataCase

  alias UrlshortnerApi.UrlShortner

  describe "urls" do
    alias UrlshortnerApi.UrlShortner.Url

    import UrlshortnerApi.UrlShortnerFixtures

    @invalid_attrs %{original_url: nil, slug: nil}

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert UrlShortner.list_urls() == [url]
    end

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

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      update_attrs = %{original_url: "some updated original_url", slug: "some updated slug"}

      assert {:ok, %Url{} = url} = UrlShortner.update_url(url, update_attrs)
      assert url.original_url == "some updated original_url"
      assert url.slug == "some updated slug"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = UrlShortner.update_url(url, @invalid_attrs)
      assert url == UrlShortner.get_url!(url.slug)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = UrlShortner.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> UrlShortner.get_url!(url.slug) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = UrlShortner.change_url(url)
    end
  end
end
