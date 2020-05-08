defmodule BoilerplateWeb.GraphQL.Types.Custom.Cursor do
  use Absinthe.Schema.Notation

  scalar :cursor, name: "Cursor" do
    serialize &Base.encode64/1
    parse &parse_cursor/1
  end

  defp parse_cursor(%Absinthe.Blueprint.Input.String{value: value}) do
    case Base.decode64(value) do
      {:ok, cursor} -> {:ok, cursor}
      _error -> :error
    end
  end

  defp parse_cursor(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_cursor(_) do
    :error
  end
end
