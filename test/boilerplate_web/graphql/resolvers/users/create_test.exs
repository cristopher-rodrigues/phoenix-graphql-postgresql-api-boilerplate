defmodule BoilerplateWeb.Graphql.Resolvers.Users.CreateTest do
  use Boilerplate.DataCase

  import Mox

  alias BoilerplateWeb.GraphQL.Resolvers.Users.Create
  alias Faker.Superhero

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/2" do
    test "creating a user" do
      {:ok, _} = Create.call(%{name: Superhero.En.name()}, %{})
    end
  end
end
