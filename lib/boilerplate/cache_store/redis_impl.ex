defmodule Boilerplate.CacheStore.RedisImpl do
  @behaviour Boilerplate.CacheStore.Behaviour

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {Redix, :start_link, [redis_url(), [name: __MODULE__]]},
      type: :supervisor
    }
  end

  @impl Boilerplate.CacheStore.Behaviour
  def with_cache(key, mfa) do
    case Redix.command(__MODULE__, ["GET", key]) do
      {:ok, result} when is_binary(result) ->
        {:ok, :erlang.binary_to_term(result)}

      _ ->
        fetch_and_build_cache(key, mfa)
    end
  end

  @impl Boilerplate.CacheStore.Behaviour
  def update_cache(key, result) do
    Redix.command(__MODULE__, ["SET", key, :erlang.term_to_binary(result)])
  end

  @impl Boilerplate.CacheStore.Behaviour
  def remove_cache(key) do
    Redix.command(__MODULE__, ["DEL", key])
  end

  defp fetch_and_build_cache(key, {mod, fun, args})
       when is_atom(mod) and is_atom(fun) and is_list(args) do
    case apply(mod, fun, args) do
      {:ok, result} ->
        update_cache(key, result)

        {:ok, result}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp redis_url do
    Application.fetch_env!(:boilerplate, :redis_cache_url)
  end
end
