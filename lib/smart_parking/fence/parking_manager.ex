defmodule SmartParking.Fence.ParkingManager do
  @moduledoc """
    A module which handles everything related to parking and manages the parking state
  """

  use GenServer
  alias SmartParking.Utils.ParkingLot

  ##############################################################################

  def start_link(slot_count \\ 6) do
    GenServer.start_link(__MODULE__, slot_count, name: __MODULE__)
  end

  @doc """
  Initialize the state of the parking lot
  """

  @impl true
  def init(slot_count) do
    parking_lot = ParkingLot.new(slot_count)
    {:ok, parking_lot}
  end

  ###############################################################################
  #######################           Public APIs           #######################
  ###############################################################################
  def state(manager \\ __MODULE__) do
    GenServer.call(manager, :state)
  end

  def create_slots(manager \\ __MODULE__, slot_count) do
    GenServer.call(manager, {:create, slot_count})
  end

  def extend_slots(manager \\ __MODULE__, slot_count) do
    GenServer.call(manager, {:extend, slot_count})
  end

  def park(manager \\ __MODULE__, registration_no, color) do
    GenServer.call(manager, {:park, registration_no, color})
  end

  def leave(manager \\ __MODULE__, slot_id) do
    GenServer.call(manager, {:leave, slot_id})
  end

  ###############################################################################
  #######################           Call handlers           #####################
  ###############################################################################
  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:create, slot_count}, _from, _state) do
    state = ParkingLot.new(slot_count)
    {:reply, state, state}
  end

  @impl true
  def handle_call({:extend, slot_count}, _from, state) do
    state_new = ParkingLot.extend(state, slot_count)
    {:reply, state_new, state_new}
  end

  @impl true
  def handle_call({:park, registration_no, color}, _from, state) do
    {status, msg, state} = ParkingLot.park(state, registration_no, color)
    {:reply, {status, msg}, state}
  end

  @impl true
  def handle_call({:leave, slot_id}, _from, state) do
    {_status, msg, state} = ParkingLot.leave(state, slot_id)
    {:reply, msg, state}
  end
end
