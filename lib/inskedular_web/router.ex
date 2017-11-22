defmodule InskedularWeb.Router do
  use InskedularWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InskedularWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", InskedularWeb do
    pipe_through :api
    resources "/schedules", ScheduleController, except: [:new, :edit]
  end
end
