defmodule BoilerplateWeb.GraphQL.Schema do
  use Absinthe.Schema

  import_types BoilerplateWeb.GraphQL.Types.Custom.UUID
  import_types BoilerplateWeb.GraphQL.Types.Custom.DateTime
  import_types BoilerplateWeb.GraphQL.Types.User
  import_types BoilerplateWeb.GraphQL.Types.RootQuery
  import_types BoilerplateWeb.GraphQL.Types.RootMutation
  import_types BoilerplateWeb.GraphQL.Types.RootSubscription

  subscription do
    import_fields :root_subscription
  end

  mutation do
    import_fields :root_mutation
  end

  query do
    import_fields :root_query
  end

  def middleware(middleware, _field, _object) do
    [BoilerplateWeb.GraphQL.Middlewares.Telemetry | middleware] ++
      [BoilerplateWeb.GraphQL.Middlewares.HandleErrors]
  end
end
