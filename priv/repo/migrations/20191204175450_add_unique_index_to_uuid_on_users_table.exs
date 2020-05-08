defmodule Boilerplate.Repo.Migrations.AddUniqueIndexToUuidOnUsersTable do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    execute("""
      CREATE UNIQUE INDEX CONCURRENTLY "unique_idx_users_on_uuid" ON "users" USING btree (uuid);
    """)
  end

  def down do
    execute("""
      DROP INDEX CONCURRENTLY IF EXISTS "unique_idx_users_on_uuid";
    """)
  end
end
