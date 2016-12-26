defmodule ExWechat.Helpers.ParamsParser do
  @moduledoc """
    Try to generate params keyword list base on params string.
  """
  alias ExWechat.Api

  @doc """
    Parse params string to params keyword list.
  """
  def parse_params(params, module \\ Api)
  def parse_params([], _module), do: []
  def parse_params(params, module) do
    params
    |> Enum.sort
    |> Enum.map(&generate_params(&1, module))
  end

  defp generate_params({key, value}, module) do
    if value do
      {key, value}
    else
      {key, get_param(key, module)}
    end
  end

  defp get_param(key, module) do
    case Keyword.has_key?(module.__info__(:functions), key) do
      true   -> apply(module, key, [])
      false  -> apply(module, :get_params, [key])
    end
  end
end
