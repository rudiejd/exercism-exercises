defmodule BirdCount do

  def today(list) when list == [], do: nil 
  def today(list), do: hd list

  def increment_day_count(list) when list == [], do: [1]
  def increment_day_count(list), do: [hd(list) + 1 | tl list]


  def has_day_without_birds?(list) when list == [], do: false 
  def has_day_without_birds?(list), do: today(list) == 0 or has_day_without_birds?(tl list)

  def total(list) when list == [], do: 0
  def total(list), do: today(list) + total(tl list)

  def busy_days(list) do
    if length(list) == 0 do
      0
    else if today(list) >= 5 do
      1 + busy_days(tl list)
    else
      busy_days(tl list)
    end
    end
  end
end
