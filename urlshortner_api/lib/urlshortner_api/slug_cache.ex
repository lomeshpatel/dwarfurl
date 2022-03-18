defmodule UrlshortnerApi.SlugCache do
  @moduledoc """
  A process that maintains an in-memory cache of slugs to be used by the UrlShortner API.
  When more than 75% of the cache has been depleted, it asynchronously requests for more slugs from the SlugProvider.
  """

  use GenServer

  require Logger

  alias UrlshortnerApi.SlugGenerator

  def get_env(key) do
    config =
      Application.get_env(:urlshortner_api, __MODULE__,
        cache_size: 100,
        max_size: 1000,
        refill_threshold: 0.25
      )

    config[key]
  end

  # Client API

  def start_link(opts) when is_list(opts) do
    [size, name] = opts
    Logger.info("Provided initial size: #{size}")
    max = get_env(:max_size)

    size =
      case size do
        s when s <= 0 -> get_env(:cache_size)
        s when max < s -> max
        s -> s
      end

    GenServer.start_link(__MODULE__, size, name: name)
  end

  def get(pid) do
    GenServer.call(pid, :pop)
  end

  def refill(pid) do
    GenServer.cast(pid, :refill)
  end

  # Server (callbacks)

  @impl true
  def init(size) do
    Logger.info("Starting Slug cache GenServer with size: #{inspect(size)}")
    {:ok, SlugGenerator.list_and_update_unused_slugs(size)}
  end

  @impl true
  def handle_call(:pop, _from, cache) do
    cache =
      if length(cache) == 0 do
        Logger.warn(
          "Slug cache is completely depleted. This should never happen. Refilling immediately..."
        )

        fetch_slugs(cache)
      else
        cache
      end

    if length(cache) - 1 <= get_env(:refill_threshold) do
      Logger.info(
        "Slug cache size: #{inspect(length(cache) - 1)} is below the threshold: #{inspect(get_env(:refill_threshold))}. Refilling asynchronously..."
      )

      refill(self())
    end

    slug = List.first(cache)

    {:reply, slug, List.delete(cache, slug)}
  end

  @impl true
  def handle_cast(:refill, cache) do
    {:noreply, cache ++ SlugGenerator.list_and_update_unused_slugs(get_env(:cache_size))}
  end

  # Private functions

  defp fetch_slugs(cache) do
    cache ++ SlugGenerator.list_and_update_unused_slugs(get_env(:cache_size))
  end
end
