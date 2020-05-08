defmodule BoilerplateWeb.Graphql.Mutations.UsersTest do
  use BoilerplateWeb.ConnCase, async: true
  import Mox
  import Boilerplate.Factory

  setup do
    verify_on_exit!()

    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)

    :ok
  end

  describe "update user mutation" do
    test "updating", %{conn: conn} do
      user = insert(:user)
      name = Faker.Superhero.name()

      mutation = """
        mutation{
          updateUser(name: "#{name}", uuid: "#{user.uuid}"){
            name
            updatedAt
          }
        }
      """

      %{"data" => %{"updateUser" => user_result}} =
        conn
        |> post("/graphql", %{query: mutation})
        |> json_response(200)

      {:ok, updated_at, _} = DateTime.from_iso8601(user_result["updatedAt"])

      assert user_result["name"] == name
      assert updated_at > user.updated_at
    end

    test "nonexistent user", %{conn: conn} do
      mutation = """
        mutation{
          updateUser(name: "#{Faker.Superhero.name()}", uuid: "#{Faker.UUID.v4()}"){
            name
            updatedAt
          }
        }
      """

      %{"data" => %{"updateUser" => user}, "errors" => [%{"message" => error_message}]} =
        conn
        |> post("/graphql", %{query: mutation})
        |> json_response(200)

      assert user == nil
      assert error_message == "User not found"
    end
  end

  describe "create user mutation" do
    test "creating", %{conn: conn} do
      name = Faker.Superhero.name()

      mutation = """
        mutation{
          createUser(name: "#{name}"){
            uuid
            name
            updatedAt
            insertedAt
          }
        }
      """

      %{"data" => %{"createUser" => user}} =
        conn
        |> post("/graphql", %{query: mutation})
        |> json_response(200)

      assert user["name"] == name
    end

    test "long name", %{conn: conn} do
      name = String.duplicate("Elixir", 31)

      mutation = """
        mutation{
          createUser(name: "#{name}"){
            uuid
            name
            updatedAt
            insertedAt
          }
        }
      """

      %{"data" => %{"createUser" => user}, "errors" => [%{"message" => error_message}]} =
        conn
        |> post("/graphql", %{query: mutation})
        |> json_response(200)

      assert user == nil
      assert error_message == "name should be at most 150 character(s)"
    end
  end
end
