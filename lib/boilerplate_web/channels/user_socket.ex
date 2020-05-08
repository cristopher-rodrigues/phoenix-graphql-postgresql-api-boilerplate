defmodule BoilerplateWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: BoilerplateWeb.GraphQL.Schema

  # transport :websocket, Phoenix.Transports.WebSocket

  # %{"session_token" => session_token}
  def connect(_params, socket, _connect_info) do
    # case Authentication.authenticate(session_token) do
    # {:ok, current_user} ->
    # context = %{current_user: current_user, session_token: session_token}

    socket =
      socket
      # |> assign(:current_user, current_user)
      # context)
      |> Absinthe.Phoenix.Socket.put_options(context: %{})

    {:ok, socket}

    #   {:error, _} ->
    #     :error
    # end
  end

  # def id(socket), do: "user_socket:#{socket.assigns.current_user.id}"
  def id(_socket), do: nil
end
