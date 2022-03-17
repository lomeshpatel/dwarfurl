defmodule UrlshortnerApi.SlugGenerator do
  @moduledoc """
  The SlugGenerator context.
  """

  require Logger

  import Ecto.Query, warn: false
  alias UrlshortnerApi.Repo
  alias Ecto.Multi

  alias UrlshortnerApi.SlugGenerator.Slug

  def get_env(key) do
    config =
      Application.get_env(:urlshortner_api, __MODULE__,
        default_slug_length: 8,
        max_slug_length: 16,
        default_slugs_batch_size: 100,
        max_slugs_batch_size: 1000
      )

    config[key]
  end

  @doc """
  Returns the list of slugs.

  ## Examples

      iex> list_slugs()
      [%Slug{}, ...]

  """
  def list_slugs do
    Repo.all(Slug)
  end

  @spec list_slugs(boolean, any) :: {any, nil | list}
  @doc """
  Return the list of slugs whose is_used column matches given value (default: false).
  Also limits the number of slugs returned.
  """
  def list_slugs(is_used, limit \\ -1) do
    query =
      if limit <= 0 do
        from s in Slug,
          where: s.is_used == ^is_used
      else
        from s in Slug,
          where: s.is_used == ^is_used,
          limit: ^limit
      end

    Repo.all(query)
  end

  @doc """
  A convenience function to return given number of unused slugs.

  It also generates new slugs if requested number of unused slugs are not found.
  """
  def list_unused_slugs(limit \\ -1) do
    slugs = list_slugs(false, limit)

    slugs =
      if is_nil(slugs) || length(slugs) <= limit do
        create_slugs_bulk(limit + get_env(:default_slugs_batch_size))
        list_slugs(false, limit)
      else
        slugs
      end

    {:ok,
     slugs
     |> Stream.map(& &1.slug)
     |> Enum.to_list()}
  end

  @doc """
  Returns given number of unused slugs after marking them as used in the DB.

  Performs select and update operations in a single transaction
  to avoid serving slugs that may have already been used by another process.

  It also generates new slugs if requested number of unused slugs are not found within the same transaction.
  """
  def list_and_update_unused_slugs(limit \\ -1) do
    result =
      Multi.new()
      |> Multi.run(:list_unused_slugs, fn _repo, _changes ->
        list_unused_slugs(limit)
      end)
      |> Multi.update_all(
        :mark_used,
        fn %{list_unused_slugs: slugs} ->
          from s in Slug, where: s.slug in ^slugs, update: [set: [is_used: true]]
        end,
        []
      )
      |> Repo.transaction()

    {:ok, %{list_unused_slugs: slugs_to_return, mark_used: {count, _}}} = result

    Logger.info("Number of slugs marked as used and are being returned: #{inspect(count)}")

    slugs_to_return
  end

  @doc """
  Returns the count of unused slugs.
  """
  def count_unused_slugs() do
    query =
      from s in Slug,
        where: s.is_used == false

    Repo.aggregate(query, :count)
  end

  @doc """
  Gets a single slug.

  Raises `Ecto.NoResultsError` if the Slug does not exist.

  ## Examples

      iex> get_slug!(123)
      %Slug{}

      iex> get_slug!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slug!(id), do: Repo.get!(Slug, id)

  @doc """
  Creates a slug.

  ## Examples

      iex> create_slug(%{field: value})
      {:ok, %Slug{}}

      iex> create_slug(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slug(attrs \\ %{}) do
    %Slug{}
    |> Slug.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates slugs in bulk.

  Number of slugs created is determined by :default_slugs_batch_size environment variable.
  """
  def create_slugs_bulk(count \\ get_env(:default_slugs_batch_size)) do
    {count, records} = Repo.insert_all(Slug, generate_slugs(count), on_conflict: :nothing)
    Logger.info("Number of new slugs generated: #{inspect(count)}")

    {count, records}
  end

  @doc """
  Updates a slug.

  ## Examples

      iex> update_slug(slug, %{field: new_value})
      {:ok, %Slug{}}

      iex> update_slug(slug, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slug(%Slug{} = slug, attrs) do
    slug
    |> Slug.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a slug.

  ## Examples

      iex> delete_slug(slug)
      {:ok, %Slug{}}

      iex> delete_slug(slug)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slug(%Slug{} = slug) do
    Repo.delete(slug)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slug changes.

  ## Examples

      iex> change_slug(slug)
      %Ecto.Changeset{data: %Slug{}}

  """
  def change_slug(%Slug{} = slug, attrs \\ %{}) do
    Slug.changeset(slug, attrs)
  end

  @doc """
  Returns a unique and random alphanumeric string of the given length.

  It leverages Erlang's :crypto module to generate random bytes and then encodes these bytes to Base64.

  In order to achieve the requested length, it generates a smaller number of bytes that multiples of 3 octets (8-bits),
  that when encoded to Base64 will generate sextets(6-bits) that are multiples of 4.
  And by removing the padding, we can ensure the requested length.

  Source: https://en.wikipedia.org/wiki/Base64
  """
  def generate_slug(_ \\ nil, len \\ get_env(:default_slug_length)) do
    len = validate_max(:max_slug_length, len)

    abs(trunc(len / 4 * 3))
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
  end

  @doc """
  Returns a list of fully constructed %Slug structs of the given size.
  """
  def generate_slugs(count \\ get_env(:default_slugs_batch_size)) do
    count = validate_max(:max_slugs_batch_size, count)

    1..abs(count)
    |> Stream.map(&generate_slug(&1))
    |> Stream.uniq()
    |> Stream.map(
      &%{
        slug: &1,
        is_used: false,
        inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
        updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      }
    )
    |> Enum.to_list()
  end

  # Private functions

  defp validate_max(config_key, value) do
    max_value = get_env(config_key)

    if value <= max_value do
      value
    else
      max_value
    end
  end
end
