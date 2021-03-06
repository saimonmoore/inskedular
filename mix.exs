defmodule Inskedular.Mixfile do
  use Mix.Project

  def project do
    [
      app: :inskedular,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Inskedular.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :eventstore,
      ]
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
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:commanded, "~> 0.15"},
      {:commanded_eventstore_adapter, "~> 0.3"},
      {:commanded_ecto_projections, "~> 0.6"},
      {:uuid, "~> 1.1"},
      {:exconstructor, "~> 1.1"},
      {:calendar, "~> 0.17"},
      {:vex, "~> 0.6"},
      {:comb, git: "https://github.com/tallakt/comb.git", branch: "master"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:ex_machina, "~> 2.1", only: :test},
      {:distillery, "~> 1.5", runtime: false},
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
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "event_store.reset": ["event_store.drop", "event_store.create", "event_store.init"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
