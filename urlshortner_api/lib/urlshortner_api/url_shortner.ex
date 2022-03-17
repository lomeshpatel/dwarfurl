defmodule UrlshortnerApi.UrlShortner do
  @moduledoc """
  The UrlShortner context.
  """

  import Ecto.Query, warn: false
  alias UrlshortnerApi.Repo

  alias UrlshortnerApi.UrlShortner.Url
  alias UrlshortnerApi.SlugCache

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %Url{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(slug), do: Repo.get!(Url, slug)

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %Url{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    slug_key =
      if Map.has_key?(attrs, :original_url) do
        :slug
      else
        "slug"
      end

    {_current_slug, new_attrs} =
      Map.get_and_update(attrs, slug_key, fn current_slug ->
        new_slug =
          if is_nil(current_slug) do
            SlugCache.get(UrlshortnerApi.SlugCache)
          else
            current_slug
          end

        {current_slug, new_slug}
      end)

    %Url{}
    |> Url.changeset(new_attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_url(url)
      {:ok, %Url{}}

      iex> delete_url(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url(%Url{} = url) do
    Repo.delete(url)
  end
end
