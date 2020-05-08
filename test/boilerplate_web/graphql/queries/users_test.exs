defmodule BoilerplateWeb.Graphql.Queries.UsersTest do
  use BoilerplateWeb.ConnCase, async: true
  import Mox
  import Boilerplate.Factory

  alias Boilerplate.ElasticMock

  setup do
    verify_on_exit!()

    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)

    :ok
  end

  describe "users list query" do
    test "querying", %{conn: conn} do
      size = 3
      users = insert_list(size, :user) |> Enum.reverse()

      query = """
      {
        users(pageSize: #{size}){
           nodes{
            uuid
            name
            insertedAt
            updatedAt
          }
          hasNextPage
          endCursor
        }
      }
      """

      res =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      users_uuid = users |> Enum.map(& &1.uuid)
      result_users_uuid = res["data"]["users"]["nodes"] |> Enum.map(& &1["uuid"])

      assert length(res["data"]["users"]["nodes"]) == 3
      assert result_users_uuid == users_uuid
    end

    test "empty result", %{conn: conn} do
      query = """
      {
        users{
           nodes{
            uuid
            name
            insertedAt
            updatedAt
          }
          hasNextPage
          endCursor
        }
      }
      """

      %{"data" => %{"users" => res}} =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["nodes"] == []
    end

    test "paginating", %{conn: conn} do
      users = insert_list(3, :user) |> Enum.reverse()

      query = """
      {
        users(pageSize: #{2}){
           nodes{
            uuid
            name
            insertedAt
            updatedAt
          }
          hasNextPage
          endCursor
        }
      }
      """

      res =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      [users, [user]] = users |> Enum.chunk_every(2, 2, [])
      users_uuid = users |> Enum.map(& &1.uuid)
      result_users_uuid = res["data"]["users"]["nodes"] |> Enum.map(& &1["uuid"])

      assert length(res["data"]["users"]["nodes"]) == 2
      assert result_users_uuid == users_uuid

      before_id = res["data"]["users"]["endCursor"]

      query = """
      {
        users(pageSize: #{1}, beforeId: "#{before_id}"){
           nodes{
            uuid
            name
            insertedAt
            updatedAt
          }
          hasNextPage
          endCursor
        }
      }
      """

      res =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert length(res["data"]["users"]["nodes"]) == 1
      assert List.first(res["data"]["users"]["nodes"])["uuid"] == user.uuid
    end
  end

  describe "find user query" do
    test "finding", %{conn: conn} do
      user = insert(:user)

      query = """
      {
        user(uuid: "#{user.uuid}"){
          uuid
          name
          insertedAt
          updatedAt
        }
      }
      """

      %{"data" => %{"user" => user_result}} =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      {:ok, updated_at, _} = DateTime.from_iso8601(user_result["updatedAt"])
      {:ok, inserted_at, _} = DateTime.from_iso8601(user_result["insertedAt"])

      assert user_result["name"] == user.name
      assert updated_at == user.updated_at
      assert inserted_at == user.inserted_at
    end

    test "not found", %{conn: conn} do
      query = """
      {
        user(uuid: "#{Faker.UUID.v4()}"){
          uuid
          name
          insertedAt
          updatedAt
        }
      }
      """

      %{"data" => %{"user" => user}} =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert user == nil
    end
  end

  describe "users search query" do
    test "searching", %{conn: conn} do
      elastic_user = %{
        "uuid" => Faker.UUID.v4(),
        "name" => Faker.Superhero.name(),
        "updated_at" => DateTime.utc_now(),
        "inserted_at" => DateTime.utc_now()
      }

      scroll = "1m"
      query = String.slice(elastic_user["name"], 0..-3)
      document = "users-test"

      query_params = %{
        query: %{
          bool: %{
            must: [
              %{
                query_string: %{
                  query: "*#{query}*",
                  default_field: "name"
                }
              }
            ],
            must_not: %{
              exists: %{
                field: "removed_at"
              }
            }
          }
        }
      }

      index = "postgresql.public.users-test"

      expect(ElasticMock, :search, fn ^query_params, ^document, ^scroll, ^index ->
        {:ok, %{scroll_id: Faker.UUID.v4(), nodes: [elastic_user]}}
      end)

      query = """
      {
        usersSearch(query: "#{query}"){
          nodes{
            uuid
            name
            updatedAt
            insertedAt
          }
          scrollId
        }
      }
      """

      %{"data" => %{"usersSearch" => res}} =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      user_result = List.first(res["nodes"])

      {:ok, updated_at, _} = DateTime.from_iso8601(user_result["updatedAt"])
      {:ok, inserted_at, _} = DateTime.from_iso8601(user_result["insertedAt"])

      assert user_result["uuid"] == elastic_user["uuid"]
      assert user_result["name"] == elastic_user["name"]
      assert updated_at == elastic_user["updated_at"]
      assert inserted_at == elastic_user["inserted_at"]
    end

    test "empty result", %{conn: conn} do
      query = Faker.Superhero.name()
      scroll = "1m"
      document = "users-test"

      query_params = %{
        query: %{
          bool: %{
            must: [
              %{
                query_string: %{
                  query: "*#{query}*",
                  default_field: "name"
                }
              }
            ],
            must_not: %{
              exists: %{
                field: "removed_at"
              }
            }
          }
        }
      }

      index = "postgresql.public.users-test"

      expect(ElasticMock, :search, fn ^query_params, ^document, ^scroll, ^index ->
        {:ok, %{scroll_id: Faker.UUID.v4(), nodes: []}}
      end)

      query = """
      {
        usersSearch(query: "#{query}"){
          nodes{
            uuid
            name
            updatedAt
            insertedAt
          }
          scrollId
        }
      }
      """

      %{"data" => %{"usersSearch" => res}} =
        conn
        |> post("/graphql", %{query: query})
        |> json_response(200)

      assert res["nodes"] == []
    end
  end
end
