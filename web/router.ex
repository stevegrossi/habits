defmodule Habits.Router do
  use Habits.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug Habits.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", Habits.API, as: :api do
    pipe_through [:api, :authenticated]

    scope "/v1", V1, as: :v1 do
      resources "/habits", HabitController do
        post "/check_in", HabitController, :check_in
        post "/check_out", HabitController, :check_out
      end
    end
  end

  scope "/", Habits do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
  end

  scope "/", Habits do
    pipe_through [:browser, :authenticated]

    get "/logout", SessionController, :delete
    get "/me", AccountController, :show

    resources "/habits", HabitController

    # get "/:year/:month/:day", HabitController, :index
  end
end
