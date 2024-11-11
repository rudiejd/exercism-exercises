defmodule Username do
  def sanitize(username) do
    # ä becomes ae
    # ö becomes oe
    # ü becomes ue
    # ß becomes ss
    Enum.reduce(username, [], fn c, acc -> 
      case c do
        ?ä -> acc ++ ~c"ae"
        ?ö -> acc ++ ~c"oe"
        ?ü -> acc ++ ~c"ue"
        ?ß -> acc ++ ~c"ss"
        ?_ -> acc ++ ~c"_"
        c when c >= ?a and c <= ?z -> acc ++ [c]
        _ -> acc
      end
    end)
  end
end
