defmodule Boilerplate.Users do
  alias Boilerplate.Users.{Create, Find, List, Remove, Scroll, Update}

  def mapping do
    %{
      properties: %{
        "id" => %{type: "integer"},
        "uuid" => %{type: "text"},
        "name" => %{type: "text"},
        # TODO: format: "dd-MM-yyyy HH:mm:ss"
        "inserted_at" => %{type: "date"},
        "updated_at" => %{type: "date"},
        "removed_at" => %{type: "date"}
      }
    }
  end

  def index do
    :boilerplate
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:index)
  end

  def document do
    :boilerplate
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:document)
  end

  defdelegate scroll(params), to: Scroll, as: :call
  defdelegate find(params), to: Find, as: :call
  defdelegate create(params), to: Create, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate list(params), to: List, as: :call
  defdelegate remove(uuid), to: Remove, as: :call
end
