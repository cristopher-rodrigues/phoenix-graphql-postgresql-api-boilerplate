defmodule BoilerplateWeb.GraphQL.Middlewares.HandleErrors do
  @behaviour Absinthe.Middleware

  alias BoilerplateWeb.ErrorHelpers

  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&ErrorHelpers.translate_error/1)
    |> Enum.map(fn {k, v} -> "#{to_string(k)} #{v}" end)
  end

  defp handle_error(error) do
    if Exception.exception?(error) do
      [Exception.message(error)]
    else
      [error]
    end
  end
end
