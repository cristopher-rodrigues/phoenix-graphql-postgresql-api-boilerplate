defmodule Boilerplate.Users.Update do
  alias Boilerplate.Repo
  alias Boilerplate.Users.Update.Params
  alias Boilerplate.Users.{Cache, Find, User}

  def call(%Params{} = params) do
    %{uuid: uuid} = params

    Find.call(uuid)
    |> handle_update(params)
    |> Cache.update()
  end

  defp handle_update({:error, reason}, _attrs), do: {:error, reason}

  defp handle_update({:ok, user}, %Params{name: name}) do
    user
    |> User.changeset(%{name: name})
    |> Repo.update()
  end
end
