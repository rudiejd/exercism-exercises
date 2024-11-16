defmodule LogParser do
  def valid_line?(line) do
    line =~ ~r/^\[(DEBUG|INFO|WARNING|ERROR)\].*/
  end

  def split_line(line) do
    Regex.split(~r/\<(\~|\*|\=|\-)*\>/, line)
  end

  def remove_artifacts(line) do
    Regex.replace(~r/end-of-line\d+/ui, line, "")
  end

  def tag_with_user_name(line) do
    match = Regex.run(~r/User\s+(\S+)\s*/u, line)
    if match != nil do
      "[USER] #{match |> tl |> hd} #{line}" 
    else
      line
    end
  end
end
