defmodule BoilerplateWeb.GraphQL.Resolvers.Users.Scroll do
  alias Boilerplate.Users.Scroll.Params

  def call(args, _resolution) do
    case Params
         |> struct(args)
         |> Boilerplate.Users.scroll() do
      {:ok, %{users: users, scroll_id: scroll_id}} ->
        {:ok, %{nodes: users, scroll_id: scroll_id}}

      _ ->
        {:ok, %{nodes: [], scroll_id: ""}}
    end
  end
end
