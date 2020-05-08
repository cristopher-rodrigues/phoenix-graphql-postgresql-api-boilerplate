defmodule BoilerplateWeb.GraphQL.Types.RootQuery do
  use Absinthe.Schema.Notation
  alias BoilerplateWeb.GraphQL.Resolvers.Users.{Find, List, Scroll}

  object :root_query do
    field :users, type: :user_list do
      description "List Users"

      arg :before_id, :cursor, description: "Pagination cursor"

      arg :page_size, :integer,
        description: "Number of items returned by the query. Default: 30. Max: 100."

      resolve &List.call/2
    end

    field :users_search, type: :user_search_list do
      description "Search Users"

      arg :query, :string, description: "Query Users' names"
      arg :scroll_id, :string, description: "Pagination scroll cursor"

      arg :page_size, :integer,
        description: "Number of items returned by the query. Default: 30. Max: 100."

      resolve &Scroll.call/2
    end

    field :user, type: :user do
      description "Find a User by its UUID"

      arg :uuid, non_null(:uuid), description: "User's uuid"

      resolve &Find.call/2
    end
  end
end
