defmodule Boilerplate.Users.Update.Params do
  @enforce_keys [:name, :uuid]
  defstruct [:name, :uuid]
end
