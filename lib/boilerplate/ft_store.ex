defmodule Boilerplate.FTStore do
  @behaviour Boilerplate.FTStore.Behaviour

  @impl Boilerplate.FTStore.Behaviour
  def bulk(lines, document, index) do
    adapter().bulk(lines, document, index)
  end

  @impl Boilerplate.FTStore.Behaviour
  def create_mapping(document, mapping, index) do
    adapter().create_mapping(document, mapping, index)
  end

  @impl Boilerplate.FTStore.Behaviour
  def create_index(index) do
    adapter().create_index(index)
  end

  @impl Boilerplate.FTStore.Behaviour
  def scroll(scroll, scroll_id) do
    adapter().scroll(scroll, scroll_id)
  end

  @impl Boilerplate.FTStore.Behaviour
  def search(query_params, document, scroll, index) do
    adapter().search(query_params, document, scroll, index)
  end

  @impl Boilerplate.FTStore.Behaviour
  def healthy do
    adapter().healthy()
  end

  defp adapter do
    :boilerplate
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:adapter)
  end
end
