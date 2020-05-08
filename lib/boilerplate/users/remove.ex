defmodule Boilerplate.Users.Remove do
  alias Boilerplate.Repo
  alias Boilerplate.Users.{Cache, Find, User}

  def call(uuid) do
    Find.call(uuid)
    |> handle_remove()
    |> Cache.remove()
  end

  defp handle_remove({:error, reason}), do: {:error, reason}

  defp handle_remove({:ok, user}) do
    user
    |> User.changeset(%{removed_at: DateTime.utc_now()})
    |> Repo.update()
  end
end
