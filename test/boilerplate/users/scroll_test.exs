defmodule Boilerplate.Users.ScrollTest do
  use Boilerplate.DataCase

  alias Boilerplate.{ElasticMock, Users}
  alias Boilerplate.Users.Scroll.Params

  describe "call/1" do
    test "searching a user" do
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

      params = %Params{query: query}

      user =
        %Users.User{}
        |> Ecto.Changeset.cast(elastic_user, Users.User.__schema__(:fields))
        |> Ecto.Changeset.apply_changes()

      {:ok, result} = Users.Scroll.call(params)

      assert result[:users] == [user]
    end

    test "empty result" do
      query = Faker.Superhero.name()

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

      document = "users-test"
      scroll = "1m"
      index = "postgresql.public.users-test"

      expect(ElasticMock, :search, fn ^query_params, ^document, ^scroll, ^index ->
        {:ok, %{scroll_id: Faker.UUID.v4(), nodes: []}}
      end)

      params = %Params{query: query}

      {:ok, result} = Users.Scroll.call(params)

      assert result[:users] === []
    end

    test "scroll" do
      scroll = "1m"
      document = "users-test"
      query = Faker.Superhero.name()

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

      elastic_user_f = %{
        "uuid" => Faker.UUID.v4(),
        "name" => Faker.Superhero.name(),
        "updated_at" => DateTime.utc_now(),
        "inserted_at" => DateTime.utc_now()
      }

      elastic_user_s = %{
        "uuid" => Faker.UUID.v4(),
        "name" => Faker.Superhero.name(),
        "updated_at" => DateTime.utc_now(),
        "inserted_at" => DateTime.utc_now()
      }

      index = "postgresql.public.users-test"

      expect(ElasticMock, :search, fn ^query_params, ^document, ^scroll, ^index ->
        {:ok,
         %{
           scroll_id: Faker.UUID.v4(),
           nodes: [elastic_user_f, elastic_user_s]
         }}
      end)

      params = %Params{query: query}

      {:ok, result} = Users.Scroll.call(params)

      result_uuids = result[:users] |> Enum.map(& &1.uuid)

      assert result_uuids == [elastic_user_f["uuid"], elastic_user_s["uuid"]]

      scroll_id = result[:scroll_id]

      expect(ElasticMock, :scroll, fn ^scroll, ^scroll_id ->
        {:ok,
         %{
           scroll_id: Faker.UUID.v4(),
           nodes: []
         }}
      end)

      params = params |> Map.put(:scroll_id, scroll_id)

      {:ok, result} = Users.Scroll.call(params)

      assert result[:users] == []
    end
  end
end
