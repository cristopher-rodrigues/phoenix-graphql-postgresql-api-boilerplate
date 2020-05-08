defmodule BoilerplateWeb.SpandexMetadata do
  alias Plug.Conn

  def customize_metadata(conn) do
    route = route_name(conn)
    method = String.upcase(conn.method)

    conn
    |> SpandexPhoenix.default_metadata()
    |> Keyword.put(:resource, method <> " " <> route)
  end

  defp route_name(%Conn{private: %{plug_route: {route, _fn}}}), do: route

  defp route_name(%Conn{request_path: request_path})
       when request_path in ["/graphql", "/graphiql"] do
    request_path
  end

  defp route_name(%Conn{path_params: path_params, path_info: path_info}) do
    "/" <> Enum.map_join(path_info, "/", &replace_path_param_with_name(path_params, &1))
  end

  defp replace_path_param_with_name(path_params, path_component) do
    decoded_component = URI.decode(path_component)

    Enum.find_value(path_params, decoded_component, fn
      {param_name, ^decoded_component} -> ":#{param_name}"
      _ -> nil
    end)
  end
end
