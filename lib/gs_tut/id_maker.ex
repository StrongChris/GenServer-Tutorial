defmodule GsTut.IDMaker do
  use GenServer

  def start_link(%{first: _start, last: _stop}=args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def reserve(metadata) do
    GenServer.call(__MODULE__, {:reserve, metadata})
  end

  def free(id) do
    GenServer.call(__MODULE__, {:free, id})
  end

  @impl true
  def init(%{first: first, last: last}) do
    state = first..last |> Enum.map(fn id -> {id, :unused} end) |> Map.new()
    {:ok, state}
  end

  @impl true
  def handle_call({:reserve, metadata}, _from, state) do
    case Enum.find(state, :no_unused_ids, fn {_id, metadata} -> metadata == :unused end) do
      :no_unused_ids ->
        {:reply, {:error, :no_unused_ids}, state}
      {id, :unused} ->
        {:reply, {:ok, id}, Map.put(state, id, metadata)}
    end
  end

  @impl true
  def handle_call({:free, id}, _from, state) do
    case Map.pop(state, id) do
      {nil, _new_state} -> {:reply, {:error, :id_not_found}, state}
      {_metadata, new_state} -> {:reply, :ok, new_state}
    end
  end
end
