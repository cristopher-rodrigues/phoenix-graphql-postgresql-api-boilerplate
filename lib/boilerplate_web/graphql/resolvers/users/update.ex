defmodule BoilerplateWeb.GraphQL.Resolvers.Users.Update do
  alias Boilerplate.Users
  alias Boilerplate.Users.Update.Params

  def call(args, _resolution) do
    Params
    |> struct(args)
    |> Users.update()
  end
end
