defmodule BoilerplateWeb.Graphql.Resolvers.Users.FindTest do
  use Boilerplate.DataCase
  import Mox
  import Boilerplate.Factory
  alias BoilerplateWeb.GraphQL.Resolvers.Users.Find

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/2" do
    test "finding a user" do
      user = insert(:user)

      {:ok, user_result} = Find.call(%{uuid: user.uuid}, %{})

      assert user_result == user
    end
  end
end
