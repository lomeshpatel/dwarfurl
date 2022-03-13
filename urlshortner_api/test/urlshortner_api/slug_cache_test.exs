defmodule UrlShortnerApi.SlugCacheTest do
  use ExUnit.Case, async: true

  alias UrlshortnerApi.SlugCache
  
  setup do
    slug_cache = start_supervised!(SlugCache)
    %{slug_cache: slug_cache}
  end

  describe "Slug Cache" do
    test "initializes with Slugs" do
      {:ok, slug_cache_pid} = SlugCache.start_link(["abcd1234", "efgh5678"])
      assert SlugCache.get(slug_cache_pid) == "abcd1234"

      # Cleanup to avoid collision with supervised server
      GenServer.stop(slug_cache_pid)
    end

    test "process restarts normally after unexpected shutdown", %{slug_cache: slug_cache} do
      Process.exit(slug_cache, :normal)

      SlugCache.refill(slug_cache, ["abcd1234", "efgh5678"])
      assert SlugCache.get(slug_cache) == "abcd1234"
    end

    test "return first slug in the cache", %{slug_cache: slug_cache} do
      SlugCache.refill(slug_cache, ["abcd1234", "efgh5678"])
      assert SlugCache.get(slug_cache) == "abcd1234"
    end

    test "removes first slug from the cache after returning", %{slug_cache: slug_cache} do
      SlugCache.refill(slug_cache, ["abcd1234", "efgh5678"])
      assert SlugCache.get(slug_cache) == "abcd1234"

      # Second call must return the 2nd element
      assert SlugCache.get(slug_cache) == "efgh5678"
    end

    test "fetches new list of slugs when the cache is exhausted", %{slug_cache: slug_cache} do
      assert SlugCache.get(slug_cache) == "test"
    end
  end
end