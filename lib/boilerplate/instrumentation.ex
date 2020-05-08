defmodule Boilerplate.Instrumentation do
  require Logger

  def init do
    Redix.Telemetry.attach_default_handler()

    events = [
      [:tesla, :request],
      [:redix, :pipeline]
    ]

    :telemetry.attach_many(
      "boilerplate-telemetry",
      events,
      &handle_event/4,
      nil
    )
  end

  def handle_event([:tesla, :request], %{request_time: duration}, %{result: result}, _config) do
    with {:ok, %{method: method, url: url, status: status}} <- result do
      upcased_method = method |> to_string() |> String.upcase()

      Logger.info("[HTTP] #{upcased_method} #{url} #{status} #{time(duration)}")
    end
  end

  def handle_event(
        [:redix, :pipeline],
        %{elapsed_time: elapsed_time},
        %{commands: commands},
        _config
      ) do
    statements =
      commands
      |> Enum.map(&List.first/1)
      |> Enum.join(", ")

    Logger.info("[Redis] #{statements} #{time(elapsed_time)}")
  end

  defp time(nil), do: ""

  defp time(time) do
    us = System.convert_time_unit(time, :native, :microsecond)
    ms = div(us, 100) / 10

    "#{:io_lib_format.fwrite_g(ms)}ms"
  end
end
