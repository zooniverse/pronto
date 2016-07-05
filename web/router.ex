defmodule Pronto.Router do
  use Pronto.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Pronto do
    pipe_through :api

    get "/stats/:key", StatController, :index
    post "/stats/:key", StatController, :upsert
    delete "/stats/:key", StatController, :delete
  end
end
