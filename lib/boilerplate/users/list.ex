defmodule Boilerplate.Users.List do
  alias Boilerplate.Repo
  alias Boilerplate.Users.List.Params
  alias Boilerplate.Users.{Queries, User}

  def call(%Params{} = params) do
    User
    |> Queries.paginate(params)
    |> Repo.all()
  end
end
