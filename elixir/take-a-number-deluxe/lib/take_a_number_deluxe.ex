defmodule TakeANumberDeluxe do
  # Client API
  use GenServer

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    state = GenServer.call(machine, :report_state)
    state
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    new_number = GenServer.call(machine, :queue_new_number)
    case new_number do
      new_number when is_integer(new_number) -> {:ok, new_number}
      _ -> {:error, new_number}
    end
  end


  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
  end

  # Server callbacks
  @impl GenServer
  def init(init_arg) do
    state_result = TakeANumberDeluxe.State.new(init_arg[:min_number], init_arg[:max_number], Keyword.get(init_arg, :auto_shutdown_timeout, :infinity))
    case state_result do
      {:ok, res} -> {:ok, res, res.auto_shutdown_timeout}
      {:error, error} -> {:error, error}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} -> {:reply, new_number, new_state, state.auto_shutdown_timeout}
      {:error, error} -> {:reply, error, state, state.auto_shutdown_timeout}
      _ -> throw("Can't handle response")
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, next_number, new_state} -> {:reply, {:ok, next_number}, new_state, state.auto_shutdown_timeout}
      {:error, error} -> {:reply, {:error, error}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset_state, %TakeANumberDeluxe.State{} = state) do
    {:ok, state} =  TakeANumberDeluxe.State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)
    {:noreply, state, state.auto_shutdown_timeout}
  end


  @impl GenServer
  def handle_info(:timeout, %TakeANumberDeluxe.State{} = state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_, %TakeANumberDeluxe.State{} = state) do
    {:noreply, state, state.auto_shutdown_timeout}
  end
end
