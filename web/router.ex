defmodule Statistics.Router do
  use Statistics.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Statistics do
    pipe_through :api

    resources "/stats", StatController
  end
end
