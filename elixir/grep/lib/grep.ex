defmodule Grep do

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  defp search(file, pattern, flags, multi) do 
    {:ok, contents} = File.read(file)

    numbers = Enum.any?(flags, fn f -> f == "-n" end)
    names = Enum.any?(flags, fn f -> f == "-l" end)
    insensitive = Enum.any?(flags, fn f -> f == "-i" end)
    invert = Enum.any?(flags, fn f -> f == "-v" end)
    match_entire_line = Enum.any?(flags, fn f -> f == "-x" end)

    lines = String.split(contents, "\n")
    matches = for n <- 0..length(lines)-1  do
      cur = 
        if insensitive, do: String.downcase(Enum.at(lines, n)), else: Enum.at(lines, n)
      modified_pattern = if insensitive, do: String.downcase(pattern), else: pattern
      is_match = String.contains?(cur, modified_pattern)
      if is_match or invert do
        if not names do
          "#{if multi, do: "#{file}:", else: ""}#{if numbers, do: "#{n + 1}:", else: "" }#{cur}"
        else
          file
        end
      end
    end
    matches |>
    Enum.filter(fn s -> not is_nil(s) and String.length(s) > 0 end) |>
    Enum.join("\n")
  end

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    res = for file <- files, do: search(file, pattern, flags, length(files) > 1)
    IO.inspect(res)
    case length(res) do
      0 -> ""
      1 -> hd(res) <> "\n"
      _ -> Enum.join(res, "\n")
    end
  end
end
