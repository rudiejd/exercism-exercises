defmodule PaintByNumber do
  defp _palette_bit_size(color_count, current_bits) do
    if Integer.pow(2, current_bits) >= color_count do
      current_bits
else
      _palette_bit_size(color_count, current_bits + 1)
end
  end

  def palette_bit_size(color_count) do
    _palette_bit_size(color_count, 0)
  end

  def empty_picture() do
    <<>>
  end

  def test_picture() do
    <<0::2, 1::2, 2::2, 3::2>>
  end

  def prepend_pixel(<<>>, color_count, pixel_color_index) do
    bitsize = palette_bit_size(color_count) 
    <<pixel_color_index::size(bitsize)>>
  end

  def prepend_pixel(picture, color_count, pixel_color_index) do
    <<prepend_pixel(<<>>, color_count, pixel_color_index)::bitstring, picture::bitstring>>
  end

  def get_first_pixel(<<>>, _), do: nil

  def get_first_pixel(picture, color_count) do
    bitsize = palette_bit_size(color_count)
    <<first::size(bitsize), _::bitstring>> = picture
    first
  end


  def drop_first_pixel(<<>>, _), do: <<>>

  def drop_first_pixel(picture, color_count) do
  bitsize = palette_bit_size(color_count)
    <<_::size(bitsize), rest::bitstring>> = picture
    rest
  end

  def concat_pictures(picture1, picture2) do
    <<picture1::bitstring, picture2::bitstring>>
  end
end
