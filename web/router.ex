defmodule Statistics.Router do
  use Statistics.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Statistics do
    pipe_through :api

    get "/stats/:key", StatController, :index
    post "/stats/:key", StatController, :upsert
    delete "/stats/:key", StatController, :delete
  end
end
