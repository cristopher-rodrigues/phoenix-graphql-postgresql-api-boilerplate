defmodule BoilerplateWeb.GraphQL.Types.RootMutation do
  use Absinthe.Schema.Notation
  alias BoilerplateWeb.GraphQL.Resolvers.Users.{Create, Remove, Update}

  object :root_mutation do
    field :create_user, type: :user do
      description "Mutation to create a User"

      arg :name, non_null(:string), description: "User's name"

      resolve &Create.call/2
    end

    field :remove_user, type: :user do
      description "Mutation to soft remove a User"

      arg :uuid, non_null(:uuid), description: "User's uuid"

      resolve &Remove.call/2
    end

    field :update_user, type: :user do
      description "Mutation to update a User"

      arg :uuid, non_null(:uuid), description: "User's uuid"
      arg :name, non_null(:string), description: "User's name"

      resolve &Update.call/2
    end
  end
end
