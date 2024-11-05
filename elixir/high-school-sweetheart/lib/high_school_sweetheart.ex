defmodule HighSchoolSweetheart do
  def first_letter(name) do
    name |>
    to_string() |>
    String.trim() |>
    String.first()
  end

  def initial(name) do
    "#{first_letter(name) |> String.upcase()}."
  end

  def initials(full_name) do
    [first | last] = String.split(full_name)
    "#{initial(first)} #{initial(last)}"
  end

  def pair(full_name1, full_name2) do
    """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     #{initials(full_name1)}  +  #{initials(full_name2)}     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
  end
end
