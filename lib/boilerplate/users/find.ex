defmodule Boilerplate.Users.Find do
  import Boilerplate.CacheStore, only: [with_cache: 2]

  alias Boilerplate.Repo
  alias Boilerplate.Users.{Queries, User}

  def call(uuid) do
    case with_cache("#{uuid}", {__MODULE__, :fetch_from_database, [uuid]}) do
      {:ok, nil} -> {:error, "User not found"}
      {:ok, user} -> {:ok, user}
    end
  end

  def fetch_from_database(uuid) do
    user =
      User
      |> Queries.by_uuid(uuid)
      |> Repo.one()

    {:ok, user}
  end
end
