defmodule ParkingLotTest do
  use ExUnit.Case
  doctest ParkingLot

  describe "Parking" do
    setup [
      :count,
      :parking_data,
      :leave_slots,
      :color,
      :registration_no,
      :invalid_registration_no
    ]

    test "create parking", %{vehicles: vehicles} do
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        refute "Sorry, parking lot is full" == ParkingLot.park(registration_no, color)
      end)
    end

    test "leave parking", %{slots: slots, vehicles: vehicles} do
      # Park vehicles
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        ParkingLot.park(registration_no, color)
      end)

      # Leave
      Enum.each(slots, fn slot ->
        assert "Slot number #{slot} is free" == ParkingLot.leave(slot)
      end)
    end

    test "invalid leave parking" do
      # setup
      invalid_slot = 99
      # invalid Leave
      assert "invalid slot id or slot already empty" == ParkingLot.leave(invalid_slot)
    end

    test "color vehicle", %{color: color, vehicles: vehicles} do
      colored_vehicles =
        vehicles |> Enum.filter(&(&1.color == color)) |> Enum.map(& &1.registration_no)

      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        ParkingLot.park(registration_no, color)
      end)

      found_colored_vechiles = ParkingLot.registration_numbers_for_cars_with_colour(color)

      Enum.each(found_colored_vechiles, fn found ->
        assert found in colored_vehicles
      end)
    end

    test "registration vechile slot", %{
      vehicles: vehicles,
      registration_no: registration_no
    } do
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        ParkingLot.park(registration_no, color)
      end)

      # we are taking the last slot so we can assume that it'll be on the last place
      assert 5 == ParkingLot.slot_number_for_registration_number(registration_no)
    end

    test "invalid registration vechile slot", %{
      invalid_registration_no: registration_no
    } do
      assert "Not found" == ParkingLot.slot_number_for_registration_number(registration_no)
    end
  end

  defp parking_data(context) do
    vehicles_data = [
      %{registration_no: "KA-03-HU-2247", color: "BLACK"},
      %{registration_no: "KA-03-HU-2248", color: "BLACK"},
      %{registration_no: "KA-03-HU-2249", color: "WHITE"},
      %{registration_no: "KA-03-HU-2240", color: "BLUE"},
      %{registration_no: "KA-03-HU-2241", color: "BLUE"}
    ]

    {:ok, Map.put(context, :vehicles, vehicles_data)}
  end

  defp count(context) do
    {:ok, Map.put(context, :count, 5)}
    {:ok, Map.put(context, :parking_lot, ParkingLot.create_parking_lot(5))}
  end

  defp leave_slots(context) do
    {:ok, Map.put(context, :slots, [2, 4, 5])}
  end

  defp color(context) do
    {:ok, Map.put(context, :color, "BLACK")}
  end

  defp registration_no(context) do
    {:ok, Map.put(context, :registration_no, "KA-03-HU-2241")}
  end

  defp invalid_registration_no(context) do
    {:ok, Map.put(context, :invalid_registration_no, "KA-03-HU")}
  end
end
