defmodule LibraryFees do


  @spec datetime_from_string(string :: String.t()) :: NaiveDateTime.t()
  def datetime_from_string(string) do
    {:ok, datetime} = NaiveDateTime.from_iso8601(string)
    datetime
  end

  @spec before_noon?(datetime :: NaiveDateTime.t()) :: boolean()
  def before_noon?(datetime) do
    datetime 
    |> NaiveDateTime.before?(datetime |> NaiveDateTime.beginning_of_day |> NaiveDateTime.add(12, :hour)) 
  end

  @spec return_date(checkout_datetime :: NaiveDateTime.t()) :: NaiveDateTime.t()
  def return_date(checkout_datetime) do
    checkout_datetime
    |> (fn dt -> if before_noon?(dt), do: NaiveDateTime.add(dt, 28, :day), else: NaiveDateTime.add(dt, 29, :day) end).()
    |> NaiveDateTime.to_date
  end

  @spec days_late(Date.t(), NaiveDateTime.t()) :: non_neg_integer()
  def days_late(planned_return_date, actual_return_datetime) do
    diff = Date.diff(NaiveDateTime.to_date(actual_return_datetime), planned_return_date)
    if diff <= 0, do: 0, else: diff
  end

  @spec monday?(NaiveDateTime.t()) :: boolean()
  def monday?(datetime) do
    date = NaiveDateTime.to_date(datetime)
    Date.diff(date, Date.beginning_of_week(date)) == 0
  end

  @spec calculate_late_fee(String.t(), String.t(), non_neg_integer()) :: non_neg_integer()
  def calculate_late_fee(checkout, return, rate) do
  
    checkout_date = checkout |> datetime_from_string 
    return_date = return |> datetime_from_string
    rate = if monday?(return_date), do: rate * 0.5, else: rate
    trunc(rate * days_late(return_date(checkout_date), return_date))
  end
end
