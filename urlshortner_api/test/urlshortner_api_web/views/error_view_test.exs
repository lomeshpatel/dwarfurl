defmodule UrlshortnerApiWeb.ErrorViewTest do
  use UrlshortnerApiWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(UrlshortnerApiWeb.ErrorView, "404.json", []) == %{
             errors: %{detail: "No URL found for that slug."}
           }
  end

  test "renders 500.json" do
    assert render(UrlshortnerApiWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
