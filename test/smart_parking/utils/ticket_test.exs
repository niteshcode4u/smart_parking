defmodule ParkingLot.Core.TicketTest do
  @moduledoc """
  Test cases for parking ticket
  """

  use ExUnit.Case
  alias ParkingLot.Core.{Vehicle, Ticket}

  @tag :wip
  test "validate ticket struct" do
    # setup
    ticket = %ParkingLot.Core.Ticket{
      id: 8,
      price: nil,
      slot_id: 1,
      timestamp_entry: ~U[2020-06-01 03:24:09.312430Z],
      timestamp_exit: nil,
      vehicle: %ParkingLot.Core.Vehicle{color: "red", registration_no: "abc"}
    }

    vehicle = Vehicle.new(registration_no: "abc", color: "red")
    struct = Ticket.new(%{vehicle: vehicle, slot_id: 1})
    assert struct.slot_id == ticket.slot_id
    assert struct.vehicle == vehicle
  end
end
