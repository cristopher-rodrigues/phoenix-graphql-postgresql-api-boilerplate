defmodule BoilerplateWeb.Graphql.Resolvers.Users.UpdateTest do
  use Boilerplate.DataCase

  import Mox

  alias BoilerplateWeb.GraphQL.Resolvers.Users.Update
  alias Faker.Superhero

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/2" do
    test "updating a user" do
      user = insert(:user)

      {:ok, _} = Update.call(%{uuid: user.uuid, name: Superhero.En.name()}, %{})
    end
  end
end
