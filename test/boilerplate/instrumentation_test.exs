defmodule Boilerplate.InstrumentationTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureLog
  alias Boilerplate.Instrumentation

  setup do
    previous_level = Logger.level()
    Logger.configure(level: :info)

    on_exit(fn ->
      Logger.configure(level: previous_level)
    end)

    :ok
  end

  describe "handle_event/4" do
    test "tesla success request" do
      duration = 1_000_000
      # TODO?
      url = "?"

      result =
        {:ok,
         %{
           method: :get,
           url: url,
           status: 200
         }}

      log =
        capture_log(fn ->
          Instrumentation.handle_event(
            [:tesla, :request],
            %{request_time: duration},
            %{result: result},
            nil
          )
        end)

      assert log =~ "[info] [HTTP] GET #{url} 200 1.0ms"
    end

    test "tesla error request" do
      duration = 1_000_000
      result = {:error, "reason"}

      log =
        capture_log(fn ->
          Instrumentation.handle_event(
            [:tesla, :request],
            %{request_time: duration},
            %{result: result},
            nil
          )
        end)

      assert log =~ ""
    end

    test "redis statement log" do
      elapsed_time = 1_000_000
      commands = [["PING"], ["PONG"], ["SET", "key", "value"]]

      log =
        capture_log(fn ->
          Instrumentation.handle_event(
            [:redix, :pipeline],
            %{elapsed_time: elapsed_time},
            %{commands: commands},
            nil
          )
        end)

      assert log =~ "[info] [Redis] PING, PONG, SET 1.0ms"
    end
  end
end
