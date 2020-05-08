defmodule BoilerplateWeb.GraphQL.Resolvers.Users.Find do
  alias Boilerplate.Users

  def call(%{uuid: uuid}, _) do
    Users.find(uuid)
  end
end
