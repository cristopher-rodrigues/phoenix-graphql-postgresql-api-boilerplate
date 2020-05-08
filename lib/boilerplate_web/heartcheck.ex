defmodule BoilerplateWeb.HeartCheck do
  use HeartCheck

  alias Boilerplate.{FTStore, Repo}

  add :database do
    case ping_repo(Repo) do
      {:ok, _} -> :ok
      {:error, exception} -> {:error, Exception.message(exception)}
    end
  end

  add :cache_redis do
    case Redix.command(Boilerplate.CacheStore.RedisImpl, ["PING"]) do
      {:ok, "PONG"} -> :ok
      {:error, exception} -> {:error, Exception.message(exception)}
    end
  end

  add :elastic do
    case FTStore.healthy() do
      :ok -> :ok
      :error -> {:error, "FTStore is unhealthy"}
    end
  end

  defp ping_repo(repo) do
    repo.query("SELECT 1")
  rescue
    exception -> {:error, exception}
  end
end
