defmodule Habits.Router do
  use Habits.Web, :router

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

  scope "/", Habits do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    get    "/logout", SessionController, :delete

    get "/me", AccountController, :show

    resources "/habits", HabitController do
      resources "/check_ins", CheckInController
    end

    get "/:year/:month/:day", HabitController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Habits do
  #   pipe_through :api
  # end
end
