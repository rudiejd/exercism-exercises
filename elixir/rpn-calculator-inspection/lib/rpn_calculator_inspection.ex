defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)
    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    Process.monitor(pid)
    receive do
        {:EXIT, ^pid, :normal} = _ -> Map.put(results, input, :ok)
        {:EXIT, ^pid, _} = _ -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end

  end

  def reliability_check(calculator, inputs) do
    old_flag_value = Process.flag(:trap_exit, true)
    res = inputs
    |> Enum.map(&start_reliability_check(calculator, &1))
    |> Enum.map(&await_reliability_check_result(&1, %{}))
    |> Enum.reduce(%{}, fn elem, acc -> Map.merge(acc, elem) end)
    Process.flag(:trap_exit, old_flag_value)
    res
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
