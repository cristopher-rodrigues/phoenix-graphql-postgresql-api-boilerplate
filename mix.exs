defmodule Boilerplate.MixProject do
  use Mix.Project

  def project do
    [
      app: :boilerplate,
      version: "0.1.0",
      elixir: "~> 1.9.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      mod: {Boilerplate.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4.11"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:elastix, ">= 0.0.0"},
      {:cors_plug, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_phoenix, "~> 1.4"},
      {:ex_machina, "~> 2.3", only: :test},
      {:mox, "~> 0.5.1", only: :test},
      {:redix, "~> 0.10.4", override: true},
      {:telemetry_poller, "~> 0.4.0"},
      {:telemetry_metrics, "~> 0.3.0"},
      {:telemetry_metrics_statsd, "~> 0.2.0"},
      {:heartcheck, "~> 0.4.1"},
      {:spandex, "~> 2.4"},
      {:spandex_datadog, "~> 0.4.1"},
      {:spandex_phoenix, "~> 0.4.1"},
      {:faker, "~> 0.13.0"},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.2"},
      {:phoenix_pubsub_redis, "~> 2.1.8"},
      {:spandex_ecto, "~> 0.6.0"},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
