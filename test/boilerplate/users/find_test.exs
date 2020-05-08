defmodule Boilerplate.Users.FindTest do
  use Boilerplate.DataCase
  import Mox
  import Boilerplate.Factory
  alias Boilerplate.Repo
  alias Boilerplate.Users.{Find, User}

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/1" do
    test "finding a user" do
      user = insert(:user)

      {:ok, user_result} = Find.call(user.uuid)

      assert user_result == user
    end

    test "not found user" do
      {:error, reason} = Find.call(Faker.UUID.v4())

      assert reason == "User not found"
    end

    test "removed user" do
      user = insert(:user)

      {:ok, user_result} = Find.call(user.uuid)

      assert user_result == user

      user
      |> User.changeset(%{removed_at: DateTime.utc_now()})
      |> Repo.update()

      {:error, reason} = Find.call(Faker.UUID.v4())

      assert reason == "User not found"
    end
  end
end
