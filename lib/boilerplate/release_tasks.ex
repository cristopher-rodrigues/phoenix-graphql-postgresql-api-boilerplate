defmodule Boilerplate.ReleaseTasks do
  alias Boilerplate.{FTStore, Repo, Users}

  @app :boilerplate

  def seed do
    migrate()

    indexed_lines =
      read_seed_file!(seed_file())
      |> Enum.map(&normalize_lines/1)
      |> Enum.reduce([], fn x, acc -> [x, %{index: %{_id: Faker.UUID.v4()}} | acc] end)
      |> Enum.reverse()

    FTStore.bulk(indexed_lines, Users.document(), Users.index())
  end

  def migrate do
    Application.load(@app)

    ecto_migrate()
    elastic_migrate()
  end

  def rollback do
    Application.load(@app)
    {:ok, _, _} = Ecto.Migrator.with_repo(Repo, &Ecto.Migrator.run(&1, :down, step: 1))
  end

  defp ecto_migrate do
    {:ok, _, _} = Ecto.Migrator.with_repo(Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def elastic_migrate do
    index = Users.index()

    FTStore.create_index(index)

    FTStore.create_mapping(
      Users.document(),
      Users.mapping(),
      index
    )
  end

  defp normalize_lines(lines) do
    lines
    |> normalize_yds
    |> normalize_lng
  end

  defp normalize_yds(%{"Yds" => yds} = line) when is_binary(yds) do
    normalized_yds = String.replace(yds, ",", "")

    Map.merge(line, %{"Yds" => normalized_yds})
  end

  defp normalize_yds(line), do: line

  defp normalize_lng(%{"Lng" => lng} = line) when is_binary(lng) do
    [distance | t] = String.split(lng, ~r{T}, include_captures: true, trim: true)

    Map.merge(line, %{"Lng" => distance, "LngCarry" => Enum.join(t, "")})
  end

  defp normalize_lng(line), do: line

  defp seed_file, do: Application.fetch_env!(:boilerplate, :seed_file)

  defp read_seed_file!(filename) do
    filename
    |> File.read!()
    |> Jason.decode!()
  end
end
