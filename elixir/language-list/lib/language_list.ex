defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove(list) do
    tl list
  end

  def first(list) do
    hd list
  end

  def count(list) do
    MapSet.size(MapSet.new(list))
  end

  def functional_list?(list) do
    Enum.any?(list, &(&1 == "Elixir"))
  end
end
