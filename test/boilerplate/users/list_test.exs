defmodule Boilerplate.Users.ListTest do
  use Boilerplate.DataCase, async: true
  import Mox
  import Boilerplate.Factory
  alias Boilerplate.{Repo, Users}
  alias Boilerplate.Users.List.Params

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/1" do
    test "listing the last 3 users" do
      users = insert_list(3, :user) |> Enum.reverse()

      params = %Params{
        page_size: 3
      }

      result = Users.List.call(params)

      users_uuid = users |> Enum.map(& &1.uuid)
      results_uuid = result |> Enum.map(& &1.uuid)

      assert length(result) == 3
      assert results_uuid == users_uuid
    end

    test "listing and ignore removed users" do
      [user | users] = insert_list(3, :user) |> Enum.reverse()

      user
      |> Users.User.changeset(%{removed_at: DateTime.utc_now()})
      |> Repo.update()

      params = %Params{page_size: 3}
      result = Users.List.call(params)

      users_uuid = users |> Enum.map(& &1.uuid)
      results_uuid = result |> Enum.map(& &1.uuid)

      assert length(result) == 2
      assert results_uuid == users_uuid
    end

    test "empty result" do
      params = %Params{}
      result = Users.List.call(params)

      assert result == []
    end

    test "paginating users' list" do
      users = insert_list(6, :user) |> Enum.reverse()
      [users_f, users_s] = users |> Enum.chunk_every(3, 3, [])

      params = %Params{
        page_size: 3
      }

      result = Users.List.call(params)

      users_uuid = users_f |> Enum.map(& &1.uuid)
      results_uuid = result |> Enum.map(& &1.uuid)

      assert length(result) == 3
      assert results_uuid == users_uuid

      before_id = "#{List.last(result).id}"
      params = params |> Map.put(:before_id, before_id)

      result = Users.List.call(params)

      users_uuid = users_s |> Enum.map(& &1.uuid)
      results_uuid = result |> Enum.map(& &1.uuid)

      assert length(result) == 3
      assert results_uuid == users_uuid
    end
  end
end
