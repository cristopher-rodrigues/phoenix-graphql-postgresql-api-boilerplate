defmodule Boilerplate.Metrics do
  import Telemetry.Metrics

  def metrics do
    [
      summary("phoenix.endpoint.stop.duration",
        tag_values: &phoenix_enpoint_stop_tag_values/1,
        tags: [:status, :request_path],
        unit: {:native, :millisecond}
      ),
      summary("redix.pipeline.duration",
        measurement: :elapsed_time,
        tag_values: &redix_pipeline_tag_values/1,
        tags: [:statements],
        unit: {:native, :millisecond}
      ),
      summary("tesla.request.duration", measurement: :request_time, unit: {:native, :millisecond}),
      summary("absinthe.resolve.field.stop.duration",
        tag_values: &absinthe_resolve_field_tag_values/1,
        tags: [:path],
        unit: {:native, :millisecond}
      ),
      summary("boilerplate.repo.query.duration",
        measurement: :total_time,
        tags: [:query],
        unit: {:native, :millisecond}
      ),
      last_value("vm.memory.atom_used", unit: :byte),
      last_value("vm.memory.binary", unit: :byte),
      last_value("vm.memory.code", unit: :byte),
      last_value("vm.memory.ets", unit: :byte),
      last_value("vm.memory.processes", unit: :byte),
      last_value("vm.memory.processes_used", unit: :byte),
      last_value("vm.memory.system", unit: :byte),
      last_value("vm.memory.total", unit: :byte),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io")
    ]
  end

  defp absinthe_resolve_field_tag_values(%{resolution: resolution}) do
    %{
      path:
        resolution |> Absinthe.Resolution.path() |> Enum.filter(&is_binary/1) |> Enum.join(".")
    }
  end

  defp phoenix_enpoint_stop_tag_values(%{conn: conn}) do
    %{
      request_path: conn.request_path,
      status: conn.status
    }
  end

  defp redix_pipeline_tag_values(%{commands: commands}) do
    statements =
      commands
      |> Enum.map(&List.first/1)
      |> Enum.join(", ")

    %{statements: statements}
  end
end
