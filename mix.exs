defmodule Habits.Mixfile do
  use Mix.Project

  def project do
    [app: :habits,
     version: "0.0.1",
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Habits.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 1.0"},
      {:comeonin, "~> 4.0.3"},
      {:plug_cowboy, "~> 2.0"},
      {:credo, "~> 0.8.6", only: :dev},
      {:ex_machina, "~> 2.2", only: :test},
      {:geoip, "~> 0.1"},
      {:gettext, "~> 0.13.1"},
      {:mix_test_watch, "~> 0.9", only: :dev},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_html, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0-rc"},
      {:jason, "~> 1.0"},
      {:phoenix_live_reload, "~> 1.1.1", only: :dev},
      {:plug_x_forwarded_for, "~> 0.1"},
      {:postgrex, ">= 0.13.3"},
      {:secure_random, "~> 0.5"},
      {:wallaby, "~> 0.19.1", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.migrate": ["ecto.migrate", "ecto.dump"],
      "ecto.rollback": ["ecto.rollback", "ecto.dump"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
