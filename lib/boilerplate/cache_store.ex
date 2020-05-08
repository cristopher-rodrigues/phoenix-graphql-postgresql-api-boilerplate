defmodule Boilerplate.CacheStore do
  @behaviour Boilerplate.CacheStore.Behaviour

  @impl Boilerplate.CacheStore.Behaviour
  def with_cache(key, mfa) do
    adapter().with_cache(key, mfa)
  end

  @impl Boilerplate.CacheStore.Behaviour
  def update_cache(key, result) do
    adapter().update_cache(key, result)
  end

  @impl Boilerplate.CacheStore.Behaviour
  def remove_cache(key) do
    adapter().remove_cache(key)
  end

  defp adapter do
    :boilerplate
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:adapter)
  end
end
