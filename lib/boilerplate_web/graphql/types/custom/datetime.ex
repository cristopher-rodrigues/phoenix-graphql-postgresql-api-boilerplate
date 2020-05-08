defmodule BoilerplateWeb.GraphQL.Types.Custom.DateTime do
  use Absinthe.Schema.Notation

  @desc """
  The [`DateTime`](https://hexdocs.pm/elixir/DateTime.html) scalar type represents a date and time in the UTC
  timezone. The DateTime appears in a JSON response as an ISO8601 formatted
  string, including UTC timezone ("Z"). The parsed date and time string will
  be converted to UTC and any UTC offset other than 0 will be rejected.
  """
  scalar :datetime, name: "DateTime" do
    serialize &DateTime.to_iso8601/1
    parse &parse_datetime/1
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, 0} -> {:ok, datetime}
      {:ok, _datetime, _offset} -> :error
      _error -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_) do
    :error
  end
end
