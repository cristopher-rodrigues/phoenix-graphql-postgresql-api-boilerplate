defmodule BoilerplateWeb.GraphQL.Resolvers.Users.List do
  alias Boilerplate.Users
  alias Boilerplate.Users.List.Params
  alias BoilerplateWeb.GraphQL.Pagination

  def call(args, _) do
    with {:ok, args} <- Pagination.transform_args(args) do
      Params
      |> struct(args)
      |> Users.list()
      |> Pagination.build_result(args)
    end
  end
end
