defmodule Boilerplate.Application do
  use Application

  alias Boilerplate.Metrics

  def start(_type, _args) do
    Boilerplate.Instrumentation.init()

    opts = [strategy: :one_for_one, name: Boilerplate.Supervisor]

    :telemetry.attach(
      "spandex-query-tracer",
      [:boilerplate, :repo, :query],
      &SpandexEcto.TelemetryAdapter.handle_event/4,
      nil
    )

    Redix.Telemetry.attach_default_handler()

    :boilerplate
    |> Application.fetch_env!(:env)
    |> children()
    |> Supervisor.start_link(opts)
  end

  def config_change(changed, _new, removed) do
    BoilerplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def children(:test), do: default_children()
  def children(_), do: default_children() ++ runtime_children()

  defp default_children do
    [
      Boilerplate.Repo,
      BoilerplateWeb.Endpoint,
      {Absinthe.Subscription, [BoilerplateWeb.Endpoint]},
      Boilerplate.CacheStore.RedisImpl
    ]
  end

  defp runtime_children do
    [
      %{
        id: Task,
        restart: :temporary,
        start: {Task, :start_link, [Boilerplate.ReleaseTasks, :migrate, []]}
      },
      {SpandexDatadog.ApiServer, Application.fetch_env!(:boilerplate, SpandexDatadog.ApiServer)},
      {TelemetryMetricsStatsd, telemetry_configs()}
    ]
  end

  defp telemetry_configs do
    :boilerplate
    |> Application.fetch_env!(TelemetryMetricsStatsd)
    |> Keyword.put(:metrics, Metrics.metrics())
  end
end
