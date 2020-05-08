defmodule BoilerplateWeb.GraphQL.Types.RootSubscription do
  use Absinthe.Schema.Notation

  object :root_subscription do
    field :users, :user do
      config fn _args, _ ->
        {:ok, topic: "user"}
      end

      trigger :create_user,
        topic: fn _ ->
          "user"
        end

      trigger :update_user,
        topic: fn _ ->
          "user"
        end

      resolve fn user, _, _ ->
        {:ok, user}
      end
    end
  end
end
