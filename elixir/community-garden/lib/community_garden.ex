# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> %{max_plot_id: 0, plots: []} end, opts)
  end

  def list_registrations(pid) do
    Agent.get(pid, & &1[:plots])
  end

  def register(pid, register_to) do
    previous_max_plot_id = Agent.get_and_update(pid, fn state ->
      {state[:max_plot_id],
       %{
         state
         | max_plot_id: state[:max_plot_id] + 1,
           plots:
             state[:plots] ++
               [%Plot{plot_id: state[:max_plot_id] + 1, registered_to: register_to}]
       }}
    end)
    %Plot{plot_id: previous_max_plot_id + 1, registered_to: register_to}
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn state ->
      %{state | plots: state[:plots] |> Enum.filter(&(&1.plot_id != plot_id))}
    end)
  end

  def get_registration(pid, plot_id) do
    registered_plot = Agent.get(pid, fn state -> state[:plots] end)
    |> Enum.filter(&(&1.plot_id == plot_id))

    case registered_plot do
      [plot] -> plot
      [] -> {:not_found, "plot is unregistered"}
      _ -> {:error, "unknown error"}
    end
  end
end
