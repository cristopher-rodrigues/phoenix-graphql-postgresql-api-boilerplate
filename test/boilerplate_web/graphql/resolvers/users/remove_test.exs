defmodule BoilerplateWeb.Graphql.Resolvers.Users.RemoveTest do
  use Boilerplate.DataCase
  import Mox
  alias BoilerplateWeb.GraphQL.Resolvers.Users.Remove

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/2" do
    test "removing a user" do
      user = insert(:user)

      {:ok, _} = Remove.call(%{uuid: user.uuid}, %{})
    end
  end
end
