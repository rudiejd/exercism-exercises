defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ Keyword.new()) do
  maximum_price = options[:maximum_price] || 100
    combos = for top <- tops,
        bottom <- bottoms,
        top[:base_color] != bottom[:base_color],
        top[:price] + bottom[:price] < maximum_price
        do
          {top, bottom}
    end
    combos
  end
end
