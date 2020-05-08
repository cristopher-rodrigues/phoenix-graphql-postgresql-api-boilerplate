defmodule BoilerplateWeb.GraphQL.Types.User do
  use Absinthe.Schema.Notation

  import_types BoilerplateWeb.GraphQL.Types.Custom.Cursor

  object :user do
    field :uuid, non_null(:id)
    field :name, non_null(:string)
    field :updated_at, non_null(:datetime)
    field :inserted_at, non_null(:datetime)
  end

  object :user_list do
    field :nodes, non_null(list_of(:user)), description: "List of users"

    field :has_next_page, non_null(:boolean),
      description: "Whether or not the result has more records stored"

    field :end_cursor, :cursor,
      description:
        "Last cursor of the result, can be passed to the after param in the next query to fetch more results"
  end

  object :user_search_list do
    field :nodes, non_null(list_of(:user)), description: "List of users"

    field :scroll_id, :string,
      description:
        "Last cursor of the result, can be passed to the after param in the next query to fetch more results"
  end
end
