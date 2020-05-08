defmodule Boilerplate.Repo do
  use Ecto.Repo,
    otp_app: :boilerplate,
    adapter: Ecto.Adapters.Postgres
end
