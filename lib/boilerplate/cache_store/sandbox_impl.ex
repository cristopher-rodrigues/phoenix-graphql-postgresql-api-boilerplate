defmodule Boilerplate.CacheStore.SandboxImpl do
  @behaviour Boilerplate.CacheStore.Behaviour

  @impl Boilerplate.CacheStore.Behaviour
  def with_cache(_key, {mod, fun, args}), do: apply(mod, fun, args)

  @impl Boilerplate.CacheStore.Behaviour
  def update_cache(_key, _result), do: {:ok, "OK"}

  @impl Boilerplate.CacheStore.Behaviour
  def remove_cache(_key), do: {:ok, "OK"}
end
