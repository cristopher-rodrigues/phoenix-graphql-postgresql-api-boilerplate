defmodule Boilerplate.Users.Cache do
  alias Boilerplate.CacheStore

  def update({:error, reason}), do: {:error, reason}

  def update({:ok, %{uuid: uuid} = user}) do
    case CacheStore.update_cache("#{uuid}", user) do
      {:ok, "OK"} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  def remove({:error, reason}), do: {:error, reason}

  def remove({:ok, %{uuid: uuid} = user}) do
    case CacheStore.remove_cache("#{uuid}") do
      {:ok, _n} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end
end
