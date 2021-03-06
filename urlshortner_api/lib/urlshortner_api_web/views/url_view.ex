defmodule UrlshortnerApiWeb.UrlView do
  use UrlshortnerApiWeb, :view
  alias UrlshortnerApiWeb.UrlView

  def render("show.json", %{url: url}) do
    %{data: render_one(url, UrlView, "url.json")}
  end

  def render("url.json", %{url: url}) do
    %{
      slug: url.slug,
      original_url: url.original_url
    }
  end
end
