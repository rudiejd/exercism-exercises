defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    [first | rest] = String.split(path, ".")
    if !is_map(data) do
      data
    else
      extract_from_path(data[first], Enum.join(rest, "."))
    end 
  end

  def get_in_path(data, path) do
    Kernel.get_in(data, String.split(path, "."))
  end
end
