defmodule BoilerplateWeb.ConnCase do
  use ExUnit.CaseTemplate

  alias Boilerplate.Repo
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      use Phoenix.ConnTest
      alias BoilerplateWeb.Router.Helpers, as: Routes
      import BoilerplateWeb.ConnCase
      import Boilerplate.Factory

      @endpoint BoilerplateWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
