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
      cur = Enum.at(lines, n)
      is_match = cond do
       insensitive  -> String.contains?(String.downcase(cur), String.downcase(pattern))
       invert and match_entire_line -> cur != pattern
       match_entire_line -> cur == pattern
       invert -> not String.contains?(cur, pattern)
       true -> String.contains?(cur, pattern)
      end
      if is_match do 
        if not names do
          "#{if multi, do: "#{file}:", else: ""}#{if numbers, do: "#{n + 1}:", else: "" }#{cur}"
        else
          file
        end
      end
    end
    matches |>
    Enum.filter(fn s -> not is_nil(s) and String.length(String.trim(s)) > 0 end) |>
    Enum.join("\n")
  end

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    res = for file <- files, do: search(file, pattern, flags, length(files) > 1) 
    filtered = Enum.filter(res, fn s -> not is_nil(s) and String.length(String.trim(s)) > 0 end) |> Enum.dedup()
    IO.inspect(filtered)
    case length(filtered) do
      0 -> ""
      1 -> hd(filtered) <> "\n"
      _ -> Enum.join(filtered, "\n")
    end
  end
end
