defmodule Boilerplate.Users.RemoveTest do
  use Boilerplate.DataCase, async: true
  import Mox
  import Boilerplate.Factory
  alias Boilerplate.Repo
  alias Boilerplate.Users.{Remove, User}

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/1" do
    test "removing a user" do
      %User{uuid: uuid, removed_at: removed_at} = insert(:user)

      assert removed_at == nil

      {:ok, user} = Remove.call(uuid)

      refute user.removed_at == nil
    end

    test "removing a user that was already removed" do
      user = insert(:user)

      assert user.removed_at == nil

      user
      |> User.changeset(%{removed_at: DateTime.utc_now()})
      |> Repo.update()

      {:error, msg} = Remove.call(user.uuid)

      assert msg == "User not found"
    end

    test "removing nonexistent user" do
      {:error, msg} = Remove.call(Faker.UUID.v4())

      assert msg == "User not found"
    end
  end
end
