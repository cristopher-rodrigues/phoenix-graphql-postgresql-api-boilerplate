defmodule Boilerplate.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :bigserial, primary_key: true, null: false
      add :uuid, :binary_id, null: false
      add :name, :string, null: false, limit: 150
      add :removed_at, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end
  end
end
