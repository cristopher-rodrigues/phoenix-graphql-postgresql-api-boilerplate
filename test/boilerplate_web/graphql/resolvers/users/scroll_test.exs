defmodule BoilerplateWeb.Graphql.Resolvers.Users.ScrollTest do
  use Boilerplate.DataCase
  import Mox

  alias Boilerplate.{ElasticMock, Users}
  alias BoilerplateWeb.GraphQL.Resolvers.Users.Scroll

  describe "call/2" do
    test "scrolling users" do
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

      {:ok, %{nodes: nodes}} = Scroll.call(%{query: query}, %{})

      user =
        %Users.User{}
        |> Ecto.Changeset.cast(elastic_user, Users.User.__schema__(:fields))
        |> Ecto.Changeset.apply_changes()

      assert nodes == [user]
    end

    test "scrolling when got an error" do
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
        {:error, Faker.Lorem.word()}
      end)

      {:ok, %{nodes: [], scroll_id: ""}} = Scroll.call(%{query: query}, %{})
    end
  end
end
