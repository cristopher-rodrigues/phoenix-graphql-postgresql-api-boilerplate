defmodule Boilerplate.Users.Scroll do
  alias Boilerplate.FTStore
  alias Boilerplate.Users
  alias Boilerplate.Users.Scroll.Params

  # @default_sort ["_doc"]
  @default_field "name"
  @default_scroll "1m"

  def call(%Params{:scroll_id => nil} = params) do
    case FTStore.search(
           search_query(params),
           Users.document(),
           @default_scroll,
           Users.index()
         ) do
      {:ok, %{nodes: nodes, scroll_id: scroll_id}} ->
        users = nodes |> Enum.map(&build_user/1)

        {:ok, %{users: users, scroll_id: scroll_id}}

      _ ->
        {:error, "Something went wrong."}
    end
  end

  def call(%Params{:scroll_id => scroll_id}) do
    case FTStore.scroll(@default_scroll, scroll_id) do
      {:ok, %{nodes: nodes, scroll_id: scroll_id}} ->
        users = nodes |> Enum.map(&build_user/1)

        {:ok, %{users: users, scroll_id: scroll_id}}

      _ ->
        {:error, "Something went wrong."}
    end
  end

  defp build_user(elastic_user) do
    %Users.User{}
    |> Ecto.Changeset.cast(elastic_user, Users.User.__schema__(:fields))
    |> Ecto.Changeset.apply_changes()
  end

  defp search_query(%Params{query: nil}), do: %{query: %{match_all: %{}}}

  defp search_query(%Params{query: query}) do
    %{
      query: %{
        bool: %{
          must: [
            %{
              query_string: %{query: "*#{query}*", default_field: @default_field}
            }
          ],
          must_not: %{
            exists: %{
              field: "removed_at"
            }
          }
        }
      }
    }

    # TODO |> sort(params)
  end
end
