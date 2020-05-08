defmodule Boilerplate.UsersTest do
  use ExUnit.Case, async: false

  alias Boilerplate.Users

  describe "mapping/0" do
    test "mapping" do
      users_mapping = %{
        properties: %{
          "id" => %{type: "integer"},
          "inserted_at" => %{type: "date"},
          "name" => %{type: "text"},
          "removed_at" => %{type: "date"},
          "updated_at" => %{type: "date"},
          "uuid" => %{type: "text"}
        }
      }

      assert Users.mapping() == users_mapping
    end
  end

  describe "index/0" do
    test "index" do
      users_index = "postgresql.public.users-test"
      assert Users.index() == users_index
    end
  end

  describe "document/0" do
    test "document" do
      users_document = "users-test"
      assert Users.document() == users_document
    end
  end
end
