defmodule ParkingLot.Utils.Ticket do
  @moduledoc """
  This module provides tickets to the vehicle
  """

  @type t :: %__MODULE__{}
  @enforce_keys ~w(id vehicle slot_id entry_time)a

  alias SmartParking.Fence.TicketManager

  defstruct id: nil,
            vehicle: %{},
            slot_id: nil,
            entry_time: nil,
            exit_time: nil,
            price: nil

  @spec new(map()) :: %{:__struct__ => atom()}
  def new(fields) do
    fields =
      Map.new()
      |> add_id(fields)
      |> add_vehicle(fields)
      |> add_slot(fields)
      |> add_timestamp()

    struct!(__MODULE__, fields)
  end

  def add_ticket(%__MODULE__{} = ticket), do: TicketManager.add_ticket(ticket)
  def get_id(ticket_id), do: TicketManager.get_ticket(ticket_id)
  def update_ticket(ticket), do: TicketManager.update_ticket_on_exit(ticket.ticket_id)
  defp add_id(ticket, fields), do: Map.put(ticket, :id, generate_id(fields))
  defp generate_id(fields), do: fields[:id] || System.unique_integer([:monotonic, :positive])
  defp add_vehicle(ticket, %{vehicle: vehicle} = _fields), do: Map.put(ticket, :vehicle, vehicle)
  defp add_slot(ticket, %{slot_id: slot_id} = _fields), do: Map.put(ticket, :slot_id, slot_id)
  defp add_timestamp(ticket), do: Map.put(ticket, :entry_time, DateTime.utc_now())
end
