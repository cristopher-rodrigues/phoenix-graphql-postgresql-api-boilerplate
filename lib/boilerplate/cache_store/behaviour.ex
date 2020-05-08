defmodule Boilerplate.CacheStore.Behaviour do
  @callback with_cache(String.t(), {atom(), atom(), List.t()}) :: {:ok, any()} | {:error, any()}
  @callback update_cache(String.t(), any()) :: {:ok, any()} | {:error, any()}
  @callback remove_cache(String.t()) :: {:ok, any()} | {:error, any()}
end
