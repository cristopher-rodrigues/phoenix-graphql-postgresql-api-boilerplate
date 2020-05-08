defmodule Boilerplate.FTStore.ElasticsearchImplTest do
  use Boilerplate.DataCase, async: true
  alias Boilerplate.FTStore.ElasticsearchImpl
  alias Faker.{Superhero, UUID}

  @url :boilerplate
       |> Application.fetch_env!(ElasticsearchImpl)
       |> Keyword.fetch!(:url)

  @mapping %{
    properties: %{
      foo: %{type: "text"}
    }
  }

  # TODO cleanup elastic?

  describe "create_mapping/3" do
    test "creating mapping" do
      index = UUID.v4()
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      {:ok, %HTTPoison.Response{status_code: 404}} =
        Elastix.Mapping.get(@url, index, document, include_type_name: true)

      assert ElasticsearchImpl.create_mapping(document, @mapping, index) == :ok

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Mapping.get(@url, index, document, include_type_name: true)
    end

    test "creating mapping twice" do
      index = UUID.v4()
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      assert ElasticsearchImpl.create_mapping(document, @mapping, index) == :ok
      assert ElasticsearchImpl.create_mapping(document, @mapping, index) == :ok
    end

    test "invalid field type" do
      index = UUID.v4()
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      invalid_mapping = %{
        properties: %{
          foo: %{type: "foo"}
        }
      }

      {:error, reason} = ElasticsearchImpl.create_mapping(document, invalid_mapping, index)

      assert reason == "No handler for type [foo] declared on field [foo]"
    end
  end

  describe "create_index/1" do
    test "creating index" do
      index = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 404}} = Elastix.Index.get(@url, index)

      assert ElasticsearchImpl.create_index(index) == :ok

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.get(@url, index)
    end

    test "creating index twice" do
      index = UUID.v4()

      assert ElasticsearchImpl.create_index(index) == :ok

      {:error, reason} = ElasticsearchImpl.create_index(index)

      assert reason =~ "already exists"
    end
  end

  describe "bulk/3" do
    test "bulking" do
      index = UUID.v4()
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Mapping.put(@url, index, document, @mapping, include_type_name: true)

      lines_list =
        0..1
        |> Enum.map(fn _ -> %{"foo" => Superhero.En.name()} end)

      lines =
        lines_list
        |> Enum.reduce([], fn x, acc -> [x, %{index: %{_id: UUID.v4()}} | acc] end)
        |> Enum.reverse()

      assert ElasticsearchImpl.bulk(lines, document, index) == :ok
    end
  end

  describe "seach/4" do
    test "seaching" do
      index = UUID.v4()
      scroll = "1m"
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Mapping.put(@url, index, document, @mapping, include_type_name: true)

      lines_list =
        0..2
        |> Enum.map(fn _ -> %{"foo" => Superhero.En.name()} end)

      lines =
        lines_list
        |> Enum.reduce([], fn x, acc -> [x, %{index: %{_id: UUID.v4()}} | acc] end)
        |> Enum.reverse()

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Bulk.post(@url, lines, index: index, type: document)

      query = %{query: %{match_all: %{}}}

      # waiting Elastic async indexing
      Process.sleep(1000)

      {:ok, %{nodes: nodes}} = ElasticsearchImpl.search(query, document, scroll, index)

      assert nodes == lines_list
    end

    test "seaching query sizing" do
      index = UUID.v4()
      scroll = "1m"
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Mapping.put(@url, index, document, @mapping, include_type_name: true)

      lines_list =
        0..1
        |> Enum.map(fn _ -> %{"foo" => Superhero.En.name()} end)

      lines =
        lines_list
        |> Enum.reduce([], fn x, acc -> [x, %{index: %{_id: UUID.v4()}} | acc] end)
        |> Enum.reverse()

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Bulk.post(@url, lines, index: index, type: document)

      query = %{query: %{match_all: %{}}, size: 1}

      # waiting Elastic async indexing
      Process.sleep(1000)

      {:ok, %{nodes: nodes}} = ElasticsearchImpl.search(query, document, scroll, index)

      assert nodes == [List.first(lines_list)]
    end
  end

  describe "scroll/2" do
    test "scrolling" do
      index = UUID.v4()
      scroll = "1m"
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Mapping.put(@url, index, document, @mapping, include_type_name: true)

      lines_list =
        0..1
        |> Enum.map(fn _ -> %{"foo" => Superhero.En.name()} end)

      lines =
        lines_list
        |> Enum.reduce([], fn x, acc -> [x, %{index: %{_id: UUID.v4()}} | acc] end)
        |> Enum.reverse()

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Bulk.post(@url, lines, index: index, type: document)

      query = %{query: %{match_all: %{}}, size: 1}

      # waiting Elastic async indexing
      Process.sleep(1000)

      {:ok, %{nodes: nodes, scroll_id: scroll_id}} =
        ElasticsearchImpl.search(query, document, scroll, index)

      assert nodes == [List.first(lines_list)]

      {:ok, %{nodes: nodes}} = ElasticsearchImpl.scroll(scroll, scroll_id)

      assert nodes == [List.last(lines_list)]
    end

    test "end of scroll" do
      index = UUID.v4()
      scroll = "1m"
      document = UUID.v4()

      {:ok, %HTTPoison.Response{status_code: 200}} = Elastix.Index.create(@url, index, %{})

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Mapping.put(@url, index, document, @mapping, include_type_name: true)

      lines_list =
        0..1
        |> Enum.map(fn _ -> %{"foo" => Superhero.En.name()} end)

      lines =
        lines_list
        |> Enum.reduce([], fn x, acc -> [x, %{index: %{_id: UUID.v4()}} | acc] end)
        |> Enum.reverse()

      {:ok, %HTTPoison.Response{status_code: 200}} =
        Elastix.Bulk.post(@url, lines, index: index, type: document)

      query = %{query: %{match_all: %{}}, size: 2}

      # waiting Elastic async indexing
      Process.sleep(1000)

      {:ok, %{nodes: nodes, scroll_id: scroll_id}} =
        ElasticsearchImpl.search(query, document, scroll, index)

      assert nodes == lines_list

      {:ok, %{nodes: nodes}} = ElasticsearchImpl.scroll(scroll, scroll_id)

      assert nodes == []
    end
  end

  describe "healthy/0" do
    test "healthy" do
      assert ElasticsearchImpl.healthy() == :ok
    end

    test "unhalthy" do
      Application.put_env(:boilerplate, ElasticsearchImpl, url: "http://localhost:9999")

      assert ElasticsearchImpl.healthy() == :error

      Application.put_env(:boilerplate, ElasticsearchImpl, url: @url)
    end
  end
end
