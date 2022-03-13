defmodule UrlshortnerApiWeb.UrlControllerTest do
  use UrlshortnerApiWeb.ConnCase

  import UrlshortnerApi.UrlShortnerFixtures

  alias UrlshortnerApi.UrlShortner.Url

  @create_attrs %{
    original_url: "some original_url",
    slug: "some slug"
  }
  # @update_attrs %{
  #   original_url: "some updated original_url",
  #   slug: "some updated slug"
  # }
  @invalid_attrs %{original_url: nil, slug: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
  #   test "lists all urls", %{conn: conn} do
  #     conn = get(conn, Routes.url_path(conn, :index))
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "create url" do
    test "renders url when data is valid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @create_attrs)
      assert %{"slug" => slug} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.url_path(conn, :show, slug))

      assert %{
               "slug" => "some slug",
               "original_url" => "some original_url",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update url" do
  #   setup [:create_url]

  #   test "renders url when data is valid", %{conn: conn, url: %Url{id: id} = url} do
  #     conn = put(conn, Routes.url_path(conn, :update, url), url: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.url_path(conn, :show, id))

  #     assert %{
  #              "id" => ^id,
  #              "original_url" => "some updated original_url",
  #              "slug" => "some updated slug"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, url: url} do
  #     conn = put(conn, Routes.url_path(conn, :update, url), url: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  describe "delete url" do
    setup [:create_url]

    test "deletes chosen url", %{conn: conn, url: url} do
      conn = delete(conn, Routes.url_path(conn, :delete, url))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.url_path(conn, :show, url))
      end
    end
  end

  defp create_url(_) do
    url = url_fixture()
    %{url: url}
  end
end
