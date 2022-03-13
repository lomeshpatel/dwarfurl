defmodule UrlshortnerApiWeb.UrlController do
  use UrlshortnerApiWeb, :controller

  alias UrlshortnerApi.UrlShortner
  alias UrlshortnerApi.UrlShortner.Url

  action_fallback UrlshortnerApiWeb.FallbackController

  def index(conn, _params) do
    urls = UrlShortner.list_urls()
    render(conn, "index.json", urls: urls)
  end

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- UrlShortner.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_path(conn, :show, url))
      |> render("show.json", url: url)
    end
  end

  def show(conn, %{"slug" => slug}) do
    url = UrlShortner.get_url!(slug)
    render(conn, "show.json", url: url)
  end

  def update(conn, %{"slug" => slug, "url" => url_params}) do
    url = UrlShortner.get_url!(slug)

    with {:ok, %Url{} = url} <- UrlShortner.update_url(url, url_params) do
      render(conn, "show.json", url: url)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    url = UrlShortner.get_url!(slug)

    with {:ok, %Url{}} <- UrlShortner.delete_url(url) do
      send_resp(conn, :no_content, "")
    end
  end
end
