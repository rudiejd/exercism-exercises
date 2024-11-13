defmodule TakeANumber do
  defp receive_loop(ticket_number) do
    receive do
      {:report_state, sender_pid} -> 
        send(sender_pid, ticket_number)
        receive_loop(ticket_number)
      {:take_a_number, sender_pid} -> 
        send(sender_pid, ticket_number + 1)
        receive_loop(ticket_number + 1)
      :stop -> exit(0)
      _ -> receive_loop(ticket_number)
    end
  end
  def start() do
    spawn(fn -> receive_loop(0) end)
  end
end
