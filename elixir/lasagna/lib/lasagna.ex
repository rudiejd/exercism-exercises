defmodule Lasagna do
  @moduledoc """
  Documentation for `Lasagna`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Lasagna.expected_minutes_in_oven()
      40
      
      iex> Lasagna.remaining_minutes_in_oven(30)
      10

      iex> Lasagna.total_time_in_minutes(3, 20)
      26

      iex> Lasagna.alarm()
      "Ding!"

  """
  def expected_minutes_in_oven(), do: 40
  def remaining_minutes_in_oven(elapsed_minutes), do: expected_minutes_in_oven() - elapsed_minutes
  def preparation_time_in_minutes(layers) do
    2 * layers
  end
  def total_time_in_minutes(layers, elapsed_minutes) do
    preparation_time_in_minutes(layers) + elapsed_minutes
  end
  def alarm(), do: "Ding!"
end

