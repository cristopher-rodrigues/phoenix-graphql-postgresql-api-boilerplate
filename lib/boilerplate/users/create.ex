defmodule Boilerplate.Users.Create do
  alias Boilerplate.Repo
  alias Boilerplate.Users.Create.Params
  alias Boilerplate.Users.{Cache, User}

  def call(%Params{} = params) do
    params
    |> create()
    |> Cache.update()
  end

  defp create(%{name: name}) do
    attrs = %{uuid: Ecto.UUID.generate(), name: name}

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
