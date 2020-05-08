defmodule BoilerplateWeb.Graphql.Subscriptions.UsersTest do
  import Mox

  use BoilerplateWeb.ConnCase, async: false
  use Phoenix.ChannelTest
  use Absinthe.Phoenix.SubscriptionTest, schema: BoilerplateWeb.GraphQL.Schema

  alias BoilerplateWeb.UserSocket

  @subscription_query """
  subscription{
    users{
      uuid
      name
    }
  }
  """

  setup do
    verify_on_exit!()

    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)

    {:ok, socket} = Phoenix.ChannelTest.connect(UserSocket, %{})
    {:ok, socket} = join_absinthe(socket)

    {:ok, socket: socket}
  end

  describe "users subscription" do
    test "user created", %{socket: socket} do
      ref = push_doc(socket, @subscription_query)

      assert_reply(ref, :ok, %{subscriptionId: _subscription_id})

      name = Faker.Superhero.name()

      create_user_mutation = """
      mutation{
        createUser(name: "#{name}"){
          uuid
          name
          insertedAt
          updatedAt
        }
      }
      """

      ref =
        push_doc(
          socket,
          create_user_mutation
        )

      assert_reply(ref, :ok, reply)
      reply_user = reply.data["createUser"]
      assert reply_user["name"] == name

      assert_push("subscription:data", push)
      push_user = push.result.data["users"]
      assert push_user["name"] == name
    end

    test "user updated", %{socket: socket} do
      ref = push_doc(socket, @subscription_query)

      assert_reply(ref, :ok, %{subscriptionId: _subscription_id})

      user = insert(:user)
      name = Faker.Superhero.name()

      create_user_mutation = """
        mutation{
          updateUser(uuid: "#{user.uuid}", name: "#{name}"){
            uuid
            name
            insertedAt
            updatedAt
          }
        }
      """

      ref =
        push_doc(
          socket,
          create_user_mutation
        )

      assert_reply(ref, :ok, reply)
      reply_user = reply.data["updateUser"]
      assert reply_user["name"] == name

      assert_push("subscription:data", push)
      push_user = push.result.data["users"]
      assert push_user["name"] == name
    end
  end
end
