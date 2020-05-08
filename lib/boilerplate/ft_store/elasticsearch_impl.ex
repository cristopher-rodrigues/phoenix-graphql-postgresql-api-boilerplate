defmodule Boilerplate.FTStore.ElasticsearchImpl do
  alias HTTPoison.Response
  alias Elastix.{Bulk, HTTP, Index, Search}

  @behaviour Boilerplate.FTStore.Behaviour

  @impl Boilerplate.FTStore.Behaviour
  def bulk(lines, document, index) do
    case Bulk.post(
           get_url(),
           lines,
           index: index,
           type: document
         ) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, %HTTPoison.Response{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      {:error, %HTTPoison.Response{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      _ -> {:error, "Bulking fail"}
    end
  end

  @impl Boilerplate.FTStore.Behaviour
  def create_mapping(document, mapping, index) do
    case Elastix.Mapping.put(
           get_url(),
           index,
           document,
           mapping,
           include_type_name: true
         ) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, %HTTPoison.Response{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      {:error, %HTTPoison.Response{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      _ -> {:error, "Mapping creation fail"}
    end
  end

  @impl Boilerplate.FTStore.Behaviour
  def create_index(index) do
    case Index.create(
           get_url(),
           index,
           %{}
         ) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, %HTTPoison.Response{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      {:error, %HTTPoison.Response{body: %{"error" => %{"reason" => reason}}}} -> {:error, reason}
      _ -> {:error, "Index creation fail"}
    end
  end

  @impl Boilerplate.FTStore.Behaviour
  def scroll(scroll, scroll_id) do
    case Search.scroll(get_url(), %{
           scroll: scroll,
           scroll_id: scroll_id
         }) do
      {:ok, %Response{body: %{"hits" => hits, "_scroll_id" => scroll_id}}} ->
        nodes = hits["hits"] |> Enum.map(fn s -> s["_source"] end)

        {:ok, %{nodes: nodes, scroll_id: scroll_id}}

      _ ->
        {:error, %{msg: "Something went wrong"}}
    end
  end

  @impl Boilerplate.FTStore.Behaviour
  def search(query_params, document, scroll, index) do
    case Search.search(
           get_url(),
           index,
           [document],
           build_search_params(query_params),
           scroll: scroll
         ) do
      {:ok, %Response{body: %{"hits" => hits, "_scroll_id" => scroll_id}}} ->
        nodes = hits["hits"] |> Enum.map(fn s -> s["_source"] end)

        {:ok, %{nodes: nodes, scroll_id: scroll_id}}

      _ ->
        {:error, %{msg: "Something went wrong"}}
    end
  end

  @impl Boilerplate.FTStore.Behaviour
  def healthy do
    case HTTP.request("GET", "#{get_url()}/_cluster/health", "") do
      {:ok, %Response{status_code: 200, body: %{"status" => "yellow"}}} -> :ok
      {:ok, %Response{status_code: 200, body: %{"status" => "green"}}} -> :ok
      _ -> :error
    end
  end

  defp build_search_params(%{size: _} = params), do: params
  defp build_search_params(params), do: params |> Map.put(:size, get_default_size())

  defp get_url do
    :boilerplate
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:url)
  end

  defp get_default_size do
    :boilerplate
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:default_size)
  end
end
