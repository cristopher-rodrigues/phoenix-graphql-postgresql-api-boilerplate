defmodule BoilerplateWeb.GraphQL.Pagination do
  @default_page_size 10
  @max_page_size 100

  def build_result([], _args) do
    {:ok, %{nodes: [], end_cursor: nil, has_next_page: false}}
  end

  def build_result(nodes, args) do
    has_next_page = length(nodes) >= args[:page_size]
    end_cursor = if has_next_page, do: build_cursor(nodes), else: nil

    {:ok, %{nodes: nodes, end_cursor: end_cursor, has_next_page: has_next_page}}
  end

  def transform_args(args) do
    args
    |> Map.update(:page_size, nil, &update_page_size/1)
    |> transform_before()
  end

  def update_page_size(nil), do: @default_page_size

  def update_page_size(page_size) do
    page_size
    |> abs()
    |> min(@max_page_size)
  end

  defp transform_before(%{before_id: cursor} = args) when is_binary(cursor) do
    args = args |> Map.put(:before_id, cursor)

    {:ok, args}
  end

  defp transform_before(args) do
    args =
      args
      |> Map.put(:before_id, nil)

    {:ok, args}
  end

  defp build_cursor(nodes) do
    node = List.last(nodes)

    "#{node.id}"
  end
end
