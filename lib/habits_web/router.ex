defmodule HabitsWeb.Router do
  use Habits.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug HabitsWeb.TokenAuthentication
  end

  scope "/api", HabitsWeb.API, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/sessions", SessionController, only: [:create]
      resources "/accounts", AccountController, only: [:create]

      scope "/" do
        pipe_through :authenticated

        get "/account", AccountController, :show, as: :account
        get "/account/achievements", AchievementController, :index, as: :account_achievements
        get "/sessions", SessionController, :index, as: :session
        delete "/sessions/:token", SessionController, :delete, as: :session

        resources "/habits", HabitController do
          post "/check_in", HabitController, :check_in, as: :check_in
          delete "/check_out", HabitController, :check_out, as: :check_out
          get "/achievements", AchievementController, :index, as: :achievements
        end
      end
    end
  end

  scope "/", HabitsWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
