defmodule BoilerplateWeb.GraphQL.Resolvers.Users.Create do
  alias Boilerplate.Users
  alias Boilerplate.Users.Create.Params

  def call(args, _resolution) do
    Params
    |> struct(args)
    |> Users.create()
  end
end
