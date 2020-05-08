defmodule Boilerplate.CacheStore.RedisImplTest do
  use Boilerplate.DataCase, async: false
  alias Boilerplate.CacheStore.RedisImpl
  alias Faker.Pokemon

  setup do
    Redix.command!(Boilerplate.CacheStore.RedisImpl, ["FLUSHALL"])

    :ok
  end

  defmodule Callback do
    def run do
      {:ok, "cool"}
    end

    def fail do
      {:error, "boom!"}
    end
  end

  describe "with_cache/2" do
    test "key not exists" do
      assert RedisImpl.with_cache("cool_key", {Callback, :run, []}) == {:ok, "cool"}

      result = Redix.command!(RedisImpl, ["GET", "cool_key"])
      assert :erlang.binary_to_term(result) == "cool"
    end

    test "key exists" do
      expected = "not cool"
      Redix.command!(RedisImpl, ["set", "cool_key", :erlang.term_to_binary(expected)])

      assert RedisImpl.with_cache("cool_key", {Callback, :run, []}) == {:ok, expected}
    end

    test "callback fails" do
      assert RedisImpl.with_cache("cool_key", {Callback, :fail, []}) == {:error, "boom!"}
      assert Redix.command!(RedisImpl, ["GET", "cool_key"]) == nil
    end
  end

  describe "update_cache/2" do
    test "set key on redis" do
      assert RedisImpl.update_cache("cool_key", "value") == {:ok, "OK"}

      result = Redix.command!(RedisImpl, ["GET", "cool_key"])
      assert :erlang.binary_to_term(result) == "value"
    end
  end

  describe "remove_cache/1" do
    test "remove key on redis" do
      key = Pokemon.En.name()
      expected = Pokemon.En.name()

      Redix.command!(RedisImpl, ["set", key, :erlang.term_to_binary(expected)])

      assert RedisImpl.with_cache(key, {Callback, :run, []}) == {:ok, expected}

      assert RedisImpl.remove_cache(key) == {:ok, 1}
    end

    test "remove nonexistent key" do
      key = Pokemon.En.name()
      assert RedisImpl.remove_cache(key) == {:ok, 0}
    end
  end
end
