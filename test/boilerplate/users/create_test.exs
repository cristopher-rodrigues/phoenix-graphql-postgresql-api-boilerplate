defmodule Boilerplate.Users.CreateTest do
  use Boilerplate.DataCase, async: true
  import Mox
  alias Boilerplate.Users.Create
  alias Boilerplate.Users.Create.Params

  setup do
    verify_on_exit!()
    stub_with(Boilerplate.CacheStoreMock, Boilerplate.CacheStore.SandboxImpl)
    :ok
  end

  describe "call/1" do
    test "creating a user" do
      params = %Params{
        name: Faker.Superhero.name()
      }

      {:ok, user} = Create.call(params)

      assert user.name == params.name
    end

    test "creating a user with long name" do
      params = %Params{
        name: String.duplicate("Elixir", 31)
      }

      {:error, _} = Create.call(params)
    end
  end
end
