defmodule Grep do

  @spec grep(String.t(), [String.t()], Keyword.t()) :: String.t()
  defp search(file, pattern, opts, multi) do 
    {:ok, contents} = File.read(file)

    lines = String.split(contents, "\n")
    matches = for n <- 0..length(lines)-1  do
      cur = Enum.at(lines, n)
      is_match = cond do
       opts[:insensitive]  -> String.contains?(String.downcase(cur), String.downcase(pattern))
       opts[:invert] and opts[:match_entire_line] -> cur != pattern
       opts[:match_entire_line] -> cur == pattern
       opts[:invert] -> not String.contains?(cur, pattern)
       true -> String.contains?(cur, pattern)      end
      if is_match and String.length(String.trim(cur)) != 0 do 
        if not opts[:names] do
          "#{if multi, do: "#{file}:", else: ""}#{if opts[:numbers], do: "#{n + 1}:", else: "" }#{cur}"
        else
          file
        end
      end
    end
    matches |>
    Enum.filter(fn s -> not is_nil(s) and String.length(String.trim(s)) > 0 end) |>
    (&(if opts[:names], do: Enum.take(&1, 1), else: &1)).() |>
    Enum.join("\n")
  end

  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    opts = [numbers: "-n" in flags, names: "-l" in flags, 
      insensitive: "-i" in flags, invert: "-v" in flags, match_entire_line: "-x" in flags]
    res = for file <- files, do: search(file, pattern, opts, length(files) > 1) 
    filtered = Enum.filter(res, fn s -> not is_nil(s) and String.length(String.trim(s)) > 0 end) 
    # IO.inspect(filtered)
    case length(filtered) do
      0 -> ""
      1 -> hd(filtered) <> "\n"
      _ -> Enum.join(Enum.dedup(filtered), "\n") <> "\n"
    end
  end
end
