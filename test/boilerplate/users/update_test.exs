defmodule Boilerplate.Users.UpdateTest do
  use Boilerplate.DataCase, async: true
  import Mox
  import Boilerplate.Factory
  alias Boilerplate.Repo
  alias Boilerplate.Users.{Update, User}
  alias Boilerplate.Users.Update.Params

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/1" do
    test "updating a user" do
      %User{uuid: uuid} = insert(:user)

      params = %Params{
        uuid: uuid,
        name: Faker.Superhero.name()
      }

      {:ok, user} = Update.call(params)

      assert user.name == params.name
    end

    test "updating a user with long name" do
      %User{uuid: uuid} = insert(:user)

      params = %Params{
        uuid: uuid,
        name: String.duplicate("Elixir", 31)
      }

      {:error, _} = Update.call(params)
    end

    test "updating nonexistent user" do
      params = %Params{
        uuid: Faker.UUID.v4(),
        name: Faker.Superhero.name()
      }

      {:error, msg} = Update.call(params)

      assert msg == "User not found"
    end

    test "updating removed user" do
      user = insert(:user)

      user
      |> User.changeset(%{removed_at: DateTime.utc_now()})
      |> Repo.update()

      params = %Params{
        uuid: user.uuid,
        name: Faker.Superhero.name()
      }

      {:error, msg} = Update.call(params)

      assert msg == "User not found"
    end
  end
end
