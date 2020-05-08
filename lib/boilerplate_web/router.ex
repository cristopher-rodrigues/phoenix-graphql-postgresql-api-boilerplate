defmodule BoilerplateWeb.Router do
  use BoilerplateWeb, :router

  pipeline :graphql do
    plug CORSPlug, origin: &BoilerplateWeb.CORS.allowed_origins/0
  end

  pipeline :monitoring do
    plug :accepts, ["json"]
  end

  scope "/monitoring" do
    pipe_through :monitoring

    forward "/health_check", BoilerplateWeb.HealthCheckPlug
    forward "/", HeartCheck.Plug, heartcheck: BoilerplateWeb.HeartCheck
  end

  scope "/graphiql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug.GraphiQL,
      schema: BoilerplateWeb.GraphQL.Schema,
      interface: :playground,
      context: %{pubsub: BoilerplateWeb.Endpoint},
      socket: BoilerplateWeb.UserSocket
  end

  scope "/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: BoilerplateWeb.GraphQL.Schema
  end
end
