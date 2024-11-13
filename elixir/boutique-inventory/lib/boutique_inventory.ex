defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    inventory
    |> Enum.sort_by(& &1[:price])
  end

  def with_missing_price(inventory) do
    inventory
    |> Enum.filter(&(&1[:price] == nil))
  end

  def update_names(inventory, old_word, new_word) do
    inventory
    |> Enum.map(&%{&1 | name: String.replace(&1[:name], old_word, new_word)})
  end

  def increase_quantity(item, count) do
    %{
      item
      | quantity_by_size: Map.new(item[:quantity_by_size], &{elem(&1, 0), elem(&1, 1) + count})
    }
  end

  def total_quantity(item) do
    Enum.reduce(item[:quantity_by_size], 0, &(elem(&1, 1) + &2))
  end
end
