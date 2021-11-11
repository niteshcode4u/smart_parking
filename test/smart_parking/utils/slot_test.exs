defmodule ParkingLot.Core.SlotTest do
  @moduledoc """
  Test cases for parking slot
  """
  use ExUnit.Case

  test "struct valid?" do
    fields = [id: 1]
    slot_struct = %ParkingLot.Core.Slot{id: 1, ticket_id: nil, type: nil}

    assert ParkingLot.Core.Slot.new(fields) == slot_struct
  end
end
