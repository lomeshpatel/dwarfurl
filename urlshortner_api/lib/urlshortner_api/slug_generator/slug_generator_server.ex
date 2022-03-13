defmodule UrlShortnerApi.SlugGeneratorServer do
  @moduledoc """
  A process that generates slugs at startup and populates the DB with them if there aren't enough unused slugs available.
  It also provides client API to fetch list of slugs on-demand as well as asynchronously.

  This module contain server functions only. Client API is provided via SlugGenerator module.
  """

  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

end
