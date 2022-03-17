defmodule UrlshortnerApiWeb.Router do
  use UrlshortnerApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", UrlshortnerApiWeb do
    pipe_through :api

    post "/urls", UrlController, :create
    get "/urls/:slug", UrlController, :show
    delete "/urls/:slug", UrlController, :delete
  end
end
