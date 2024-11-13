defmodule DNA do
  def encode_nucleotide(code_point) do
    case code_point do
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
      ?\s -> 0b0000
    end
  end

  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0001 -> ?A
      0b0010 -> ?C 
      0b0100 -> ?G
      0b1000 -> ?T
      0b0000 -> ?\s
    end
  end

  defp do_encode(acc, []), do: acc

  defp do_encode(acc, rem) do
    [nucleotide | rest] = rem
    do_encode(<< acc::bitstring, encode_nucleotide(nucleotide)::size(4) >>, rest)
  end

  def encode(dna) do 
    do_encode(<<>>, dna)
  end

  defp do_decode(acc, <<>>) do
    acc
  end

  defp do_decode(acc, rem) do
    <<first::size(4), rest::bitstring>> = rem
    do_decode(acc ++ [decode_nucleotide(first)], rest) 
  end

  def decode(dna) do
    do_decode([], dna)
  end
end
