defmodule BoilerplateWeb.HealthCheckPlug do
  @behaviour Plug

  import Plug.Conn

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    body = Jason.encode!(%{status: :ok})

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, body)
    |> halt()
  end
end
