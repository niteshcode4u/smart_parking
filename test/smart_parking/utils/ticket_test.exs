defmodule ParkingLot.Utils.TicketTest do
  @moduledoc """
  Test cases for parking ticket
  """

  use ExUnit.Case
  alias ParkingLot.Utils.{Vehicle, Ticket}

  test "validate ticket struct" do
    # setup
    ticket = %ParkingLot.Utils.Ticket{
      id: 8,
      price: nil,
      slot_id: 1,
      entry_time: ~U[2020-06-01 03:24:09.312430Z],
      exit_time: nil,
      vehicle: %ParkingLot.Utils.Vehicle{color: "red", registration_no: "abc"}
    }

    vehicle = Vehicle.new(registration_no: "abc", color: "red")
    struct = Ticket.new(%{vehicle: vehicle, slot_id: 1})
    assert struct.slot_id == ticket.slot_id
    assert struct.vehicle == vehicle
  end
end
