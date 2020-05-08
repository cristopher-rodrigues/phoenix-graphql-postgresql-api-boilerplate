defmodule BoilerplateWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: BoilerplateWeb

      import Plug.Conn
      alias BoilerplateWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/boilerplate_web/templates",
        namespace: BoilerplateWeb

      import Phoenix.Controller, only: [view_module: 1]

      use Phoenix.HTML

      alias BoilerplateWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
