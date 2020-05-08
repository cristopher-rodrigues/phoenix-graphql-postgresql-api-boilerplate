defmodule Boilerplate.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uuid, Ecto.UUID
    field :name, :string
    field :removed_at, :utc_datetime_usec
    timestamps(type: :utc_datetime_usec)
  end

  @required_fields [:uuid, :name]
  @optional_fields [:removed_at]

  def changeset(user, params) do
    user
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:uuid, name: :unique_idx_users_on_uuid)
    |> validate_length(:name, max: 150)
  end
end
