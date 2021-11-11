defmodule ParkingLot.Core.VechileTest do
  @moduledoc """
  Test cases for parked vechile
  """

  use ExUnit.Case
  alias ParkingLot.Core.Vehicle

  test "Vehicle struct" do
    vehicle = %Vehicle{color: "red", registration_no: "abc"}

    assert vehicle == Vehicle.new(registration_no: "abc", color: "red")
  end
end
