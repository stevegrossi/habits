defmodule Habits.Mixfile do
  use Mix.Project

  def project do
    [app: :habits,
     version: "0.0.1",
     elixir: "~> 1.3.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Habits, []},
     applications: app_list(Mix.env)]
  end

  defp app_list(:test), do: [:ex_machina | app_list]
  defp app_list(_),  do: app_list
  defp app_list,  do: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy,
                       :logger, :gettext, :phoenix_ecto, :postgrex, :tzdata,
                      :comeonin]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0.1"},
      {:phoenix_ecto, "~> 3.0.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.5"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11.0"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 2.0"},
      {:secure_random, "~> 0.5"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:ex_machina, "~> 1.0", only: :test},
      {:credo, "~> 0.5", only: :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
