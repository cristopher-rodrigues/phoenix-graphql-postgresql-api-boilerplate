defmodule BoilerplateWeb.GraphQL.Resolvers.Users.Remove do
  alias Boilerplate.Users

  def call(%{uuid: uuid}, _resolution) do
    Users.remove(uuid)
  end
end
