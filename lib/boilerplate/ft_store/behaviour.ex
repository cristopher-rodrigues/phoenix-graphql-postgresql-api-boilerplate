defmodule Boilerplate.FTStore.Behaviour do
  @callback create_index(String.t()) :: {:ok, any()} | {:error, any()}
  @callback healthy() :: :ok | :error
  @callback bulk(list(), String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  @callback scroll(String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  @callback search(map(), String.t(), String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  @callback create_mapping(String.t(), String.t(), String.t()) :: {:ok, any()} | {:error, any()}
end
