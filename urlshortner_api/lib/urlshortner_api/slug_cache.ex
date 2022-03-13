defmodule UrlshortnerApi.SlugCache do
  @moduledoc """
  A process that maintains an in-memory cache of slugs to be used by the UrlShortner API.
  When more than 75% of the cache has been depleted, it asynchronously requests for more slugs from the SlugProvider.
  """

  use GenServer

  require Logger

  # Client API

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def get(pid) do
    GenServer.call(pid, :pop)
  end

  def refill(pid, more_slugs) do
    GenServer.cast(pid, {:refill, more_slugs})
  end

  # Server (callbacks)

  @impl true
  def init(cache) do
    {:ok, cache}
  end

  @impl true
  def handle_call(:pop, _from, cache) do
    cache =
      if is_nil(List.first(cache)) do
        fetch_slugs(cache)
      else
        cache
      end

    slug = List.first(cache)

    {:reply, slug, List.delete(cache, slug)}
  end

  @impl true
  def handle_cast({:refill, more_slugs}, cache) do
    {:noreply, cache ++ more_slugs}
  end

  # Private functions

  defp fetch_slugs(cache) do
    cache ++ ["test", "test1", "test2"]
  end
end
