defmodule UrlshortnerApi.SlugGeneratorTest do
  use UrlshortnerApi.DataCase
  require Logger

  alias UrlshortnerApi.SlugGenerator

  describe "Slugs Generator" do
    alias UrlshortnerApi.SlugGenerator.Slug

    import UrlshortnerApi.SlugGeneratorFixtures

    @invalid_attrs %{is_used: nil, slug: nil}

    test "generate_slug/2 returns unique and random slug of given length" do
      assert String.length(SlugGenerator.generate_slug(nil, 10)) == 10
    end

    test "generate_slug/2 returns unique and random slug of default length" do
      assert String.length(SlugGenerator.generate_slug()) ==
               SlugGenerator.get_env(:default_slug_length)
    end

    test "generate_slug/2 returns unique and random slug of absolute length" do
      assert String.length(SlugGenerator.generate_slug(nil, -6)) == 6
    end

    test "generate_slug/2 does not exceed maximum slug length" do
      max_length = SlugGenerator.get_env(:max_slug_length)
      assert String.length(SlugGenerator.generate_slug(nil, max_length + 200)) == max_length
    end

    test "generate_slugs/1 returns list of new slugs structs of upto default size" do
      slugs = SlugGenerator.generate_slugs()

      assert 0 < length(slugs) &&
               length(slugs) <= SlugGenerator.get_env(:default_slugs_batch_size)
    end

    test "generate_slugs/1 returns list of new slugs structs of upto given size" do
      slugs = SlugGenerator.generate_slugs(234)
      assert 0 < length(slugs) && length(slugs) <= 234
    end

    test "generate_slugs/1 returns list of new slugs structs of upto absolute given size" do
      slugs = SlugGenerator.generate_slugs(-24)
      assert 0 < length(slugs) && length(slugs) <= 24
    end

    test "generate_slugs/1 does not exceed maximum batch size" do
      max_size = SlugGenerator.get_env(:max_slugs_batch_size)
      slugs = SlugGenerator.generate_slugs(max_size + 100)
      assert 0 < length(slugs) && length(slugs) <= max_size
    end

    test "generate_slugs/1 returns list of new slugs structs with slugs of default size" do
      slug = List.first(SlugGenerator.generate_slugs(1))
      assert String.length(slug.slug) == 8
      assert slug.is_used == false
      assert !is_nil(slug.inserted_at)
      assert !is_nil(slug.updated_at)
    end

    test "list_slugs/0 returns all slugs 1 record" do
      Logger.info("Total slugs: #{inspect(length(SlugGenerator.list_slugs()))}")
      slug = slug_fixture()
      assert SlugGenerator.list_slugs() == [slug]
    end

    test "list_slugs/0 returns all slugs more than 1 records" do
      Logger.info("Total slugs: #{inspect(length(SlugGenerator.list_slugs()))}")
      {count, _records} = slug_fixture_bulk()
      queried_slugs = SlugGenerator.list_slugs()

      assert length(queried_slugs) == count
    end

    test "list_slugs/2 returns all used slugs" do
      Logger.info("Total slugs: #{inspect(length(SlugGenerator.list_slugs()))}")
      slug_fixture()
      {_count, _records} = slug_fixture_bulk()
      queried_slugs = SlugGenerator.list_slugs(true)

      assert length(queried_slugs) == 1
    end

    test "list_slugs/2 returns all unused slugs" do
      slug_fixture()
      {count, _records} = slug_fixture_bulk()
      queried_slugs = SlugGenerator.list_slugs(false)

      assert length(queried_slugs) == count
    end

    test "list_slugs/2 returns requested number of unused slugs" do
      slug_fixture()
      {count, _records} = slug_fixture_bulk()
      limit = count - 5
      queried_slugs = SlugGenerator.list_slugs(false, limit)

      assert length(queried_slugs) == limit
    end

    test "list_unused_slugs/1 returns all unused slugs" do
      slug_fixture()
      {count, _records} = slug_fixture_bulk()
      {_, queried_slugs} = SlugGenerator.list_unused_slugs()

      assert length(queried_slugs) == count
    end

    test "list_unused_slugs/1 returns requested number of unused slugs" do
      slug_fixture()
      {count, _records} = slug_fixture_bulk()
      limit = count - 5
      {_, queried_slugs} = SlugGenerator.list_unused_slugs(limit)

      assert length(queried_slugs) == limit
    end

    test "list_unused_slugs/1 returns requested number of unused slugs after generating new ones if none found" do
      slug_fixture()
      limit = SlugGenerator.get_env(:default_slugs_batch_size) - 5
      {_, queried_slugs} = SlugGenerator.list_unused_slugs(limit)

      assert length(queried_slugs) == limit
    end

    test "list_unused_slugs/1 returns requested number of unused slugs after generating new ones if less than requested found" do
      slug_fixture(%{
        slug: "abcd1234",
        is_used: false
      })

      limit = SlugGenerator.get_env(:default_slugs_batch_size) - 5
      {_, queried_slugs} = SlugGenerator.list_unused_slugs(limit)

      assert length(queried_slugs) == limit
    end

    test "list_and_update_unused_slugs/1 returns requested number of slugs and marks them used" do
      {count, _records} = slug_fixture_bulk()
      limit = count - 5

      assert length(SlugGenerator.list_and_update_unused_slugs(limit)) == limit
      assert length(SlugGenerator.list_slugs(true)) == count - limit
    end

    test "list_and_update_unused_slugs/1 returns default batch size number of slugs and marks them used when no limit is specified" do
      {count, _records} = slug_fixture_bulk()

      assert length(SlugGenerator.list_and_update_unused_slugs()) ==
               SlugGenerator.get_env(:default_slugs_batch_size)

      assert length(SlugGenerator.list_slugs(true)) == count
    end

    test "count_unused_slugs/0 returns count of unused slugs" do
      slug_fixture()
      {count, _records} = slug_fixture_bulk()

      assert SlugGenerator.count_unused_slugs() == count
    end

    test "get_slug!/1 returns the slug with given id" do
      slug = slug_fixture()
      assert SlugGenerator.get_slug!(slug.slug) == slug
    end

    test "create_slug/1 with valid data creates a slug" do
      valid_attrs = %{is_used: true, slug: "some slug"}

      assert {:ok, %Slug{} = slug} = SlugGenerator.create_slug(valid_attrs)
      assert slug.is_used == true
      assert slug.slug == "some slug"
    end

    test "create_slug/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SlugGenerator.create_slug(@invalid_attrs)
    end

    test "create_slug/1 without data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SlugGenerator.create_slug()
    end

    test "create_slugs_bulk/0 creates slugs in bulk" do
      {count, _records} = SlugGenerator.create_slugs_bulk()

      assert count == SlugGenerator.get_env(:default_slugs_batch_size)
    end

    test "update_slug/2 with valid data updates the slug" do
      slug = slug_fixture()
      update_attrs = %{is_used: false, slug: "some updated slug"}

      assert {:ok, %Slug{} = slug} = SlugGenerator.update_slug(slug, update_attrs)
      assert slug.is_used == false
      assert slug.slug == "some updated slug"
    end

    test "update_slug/2 with invalid data returns error changeset" do
      slug = slug_fixture()
      assert {:error, %Ecto.Changeset{}} = SlugGenerator.update_slug(slug, @invalid_attrs)
      assert slug == SlugGenerator.get_slug!(slug.slug)
    end

    test "delete_slug/1 deletes the slug" do
      slug = slug_fixture()
      assert {:ok, %Slug{}} = SlugGenerator.delete_slug(slug)
      assert_raise Ecto.NoResultsError, fn -> SlugGenerator.get_slug!(slug.slug) end
    end

    test "change_slug/1 returns a slug changeset" do
      slug = slug_fixture()
      assert %Ecto.Changeset{} = SlugGenerator.change_slug(slug)
    end
  end
end
