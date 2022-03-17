defmodule UrlshortnerApiWeb.UrlControllerTest do
  use UrlshortnerApiWeb.ConnCase

  import UrlshortnerApi.UrlShortnerFixtures

  alias UrlshortnerApi.UrlShortner.Url
  alias UrlshortnerApi.SlugCache
  alias UrlshortnerApi.SlugGenerator

  require Logger

  @create_attrs %{
    original_url: "https://www.looneytunes.com/eeeeeeeeeeehhhhh/whats/up/doc",
    slug: "someslug"
  }
  @invalid_attrs %{original_url: nil, slug: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    slug_cache =
      start_supervised!({SlugCache, [SlugCache.get_env(:cache_size), UrlshortnerApi.SlugCache]})

    %{slug_cache: slug_cache}
  end

  describe "create url" do
    test "returns url when data is valid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @create_attrs)
      assert %{"slug" => slug} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.url_path(conn, :show, slug))

      assert redirected_to(conn, :moved_permanently) ==
               "https://www.looneytunes.com/eeeeeeeeeeehhhhh/whats/up/doc"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when no body is provided", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when provided slug is too short", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: %{@create_attrs | slug: "a"})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when provided slug is too long", %{conn: conn} do
      long_slug =
        1..SlugGenerator.get_env(:max_slug_length)
        |> Enum.reduce("ab", fn _, acc -> acc <> "cd" end)

      conn = post(conn, Routes.url_path(conn, :create), url: %{@create_attrs | slug: long_slug})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "fetch original URL" do
    setup [:create_url]

    test "redirects to the original URL", %{conn: conn, url: url} do
      conn = get(conn, Routes.url_path(conn, :show, url.slug))
      assert redirected_to(conn, :moved_permanently) == url.original_url
    end

    test "returns 404 with error when original URL is not found", %{conn: conn, url: url} do
      url = Map.update(url, :slug, "not-found", fn s -> "not-found" end)

      assert_error_sent :not_found, fn ->
        get(conn, Routes.url_path(conn, :show, url))
      end
    end
  end

  describe "delete url" do
    setup [:create_url]

    test "deletes chosen url", %{conn: conn, url: url} do
      conn = delete(conn, Routes.url_path(conn, :delete, url))
      assert response(conn, :no_content)

      assert_error_sent :not_found, fn ->
        get(conn, Routes.url_path(conn, :show, url))
      end
    end
  end

  defp create_url(_) do
    url = url_fixture()
    %{url: url}
  end
end
