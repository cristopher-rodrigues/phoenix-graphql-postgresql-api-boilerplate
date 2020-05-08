defmodule Boilerplate.Users.Queries do
  import Ecto.Query

  def by_uuid(queryable, uuid) do
    where(queryable, [user], user.uuid == ^uuid)
    |> without_removed()
  end

  def paginate(queryable, %{
        before_id: before_id,
        page_size: page_size
      }) do
    queryable
    |> without_removed
    |> by_cursor(before_id)
    |> order_by([u], desc: u.id)
    |> limit(^page_size)
  end

  defp without_removed(schema) do
    where(schema, [u], is_nil(u.removed_at))
  end

  defp by_cursor(queryable, before_id)
       when is_nil(before_id) do
    queryable
  end

  defp by_cursor(queryable, before_id) do
    queryable
    |> where([u], u.id < ^before_id)
  end
end
