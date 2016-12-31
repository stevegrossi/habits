defmodule Habits.Router do
  use Habits.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", Habits.API, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/habits", HabitController do
        post "/check_in", HabitController, :check_in, as: :check_in
        post "/check_out", HabitController, :check_out, as: :check_out
      end
    end
  end

  scope "/", Habits do
    pipe_through :browser # Use the default browser stack

    get "*path", PageController, :index
  end
end
