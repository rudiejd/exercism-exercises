defmodule TopSecret do
  def to_ast(string) do
    {:ok, quoted} = Code.string_to_quoted(string)
    quoted
  end

  def decode_secret_message_part(ast, acc) do
    dbg()
    case ast do
      {:defp, _, [{_, _, nil}, _]} -> {ast,  ["" | acc]}
      {:def, _, [{_, _, nil}, _]} -> {ast,  ["" | acc]}
      {:defp, _, [{:when, _, [{func_name, _, args}, _]}, _]} -> {ast,  [func_name |> to_char_list |> Enum.take(length(args)) |> to_string() | acc]}
      {:def, _, [{:when, _, [{func_name, _, args}, _]}, _]} -> {ast,  [func_name |> to_char_list |> Enum.take(length(args)) |> to_string() | acc]}
      {:def, _, [{func_name, _, args}, _]} -> {ast,  [func_name |> to_char_list |> Enum.take(length(args)) |> to_string() | acc]}
      {:defp, _, [{func_name, _, args}, _]} -> {ast,  [func_name |> to_char_list |> Enum.take(length(args)) |> to_string() | acc]}
      _ -> {ast, acc}
    end
  end

  def decode_secret_message(string) do
    ast = to_ast(string)
    {_, acc} = Macro.prewalk(ast, [], fn ast, acc -> decode_secret_message_part(ast, acc) end)
    acc
    |> Enum.reverse
    |> to_string
  end
end
