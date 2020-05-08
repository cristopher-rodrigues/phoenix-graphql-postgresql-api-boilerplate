defmodule BoilerplateWeb.CORS do
  def allowed_origins do
    origins =
      :boilerplate
      |> Application.fetch_env!(__MODULE__)
      |> Keyword.fetch!(:allowed_origins)
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&build_single_pattern/1)
      |> Enum.join("|")

    Regex.compile!("^#{origins}$")
  end

  defp build_single_pattern(origin) do
    pattern =
      origin
      |> Regex.escape()
      |> String.replace("\\*", ".+")

    "(#{pattern})"
  end
end
