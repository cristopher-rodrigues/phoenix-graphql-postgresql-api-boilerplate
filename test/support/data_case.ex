defmodule Boilerplate.DataCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Finally, if the test case interacts with the datasource,
  so changes done to the database
  are reverted at the end of every test.
  """

  use ExUnit.CaseTemplate

  alias Boilerplate.Repo
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      use Phoenix.ConnTest

      @endpoint Boilerplate.Endpoint

      import Boilerplate.Factory
      import Mox
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end
end
