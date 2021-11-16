defmodule SmartParkingTest do
  use ExUnit.Case
  doctest SmartParking

  describe "Parking" do
    setup [
      :count,
      :parking_data,
      :leave_slots,
      :color,
      :registration_no,
      :invalid_registration_no
    ]

    test "create slots" do
      assert "Invalid slot count type" == SmartParking.create_parking_lot("3")
      assert "Invalid slot count type" == SmartParking.create_parking_lot("Hello")

      assert %SmartParking.Utils.ParkingLot{id: _id, slots: _slots, used_slots: []} =
               SmartParking.create_parking_lot(5)
    end

    test "extend slots" do
      assert "Invalid slot count type" == SmartParking.extend_slots("3")
      assert "Invalid slot count type" == SmartParking.extend_slots("Hello")

      assert %SmartParking.Utils.ParkingLot{id: _id, slots: _slots, used_slots: _used_slots} =
               SmartParking.extend_slots(5)
    end

    test "park your vehicle", %{vehicles: vehicles} do
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        refute "Sorry, no parking lot available currently" ==
                 SmartParking.park(registration_no, color)
      end)
    end

    test "no parking in case parking is full", %{vehicles: vehicles} do
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        assert :success == SmartParking.park(registration_no, color)
      end)

      assert "Sorry, no parking lot available currently" ==
               SmartParking.park("KA-03-HU-2243", "Green")
    end

    test "no parking for duplicate vehicle" do
      # set up
      registration_no = "KA-03-HU-2241"
      color = "BLUE"

      assert :success == SmartParking.park(registration_no, color)
      assert "Same car already parked" == SmartParking.park(registration_no, color)
    end

    test "leave parking slot", %{slots: slots, vehicles: vehicles} do
      # Park vehicles
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        SmartParking.park(registration_no, color)
      end)

      # Leave
      Enum.each(slots, fn slot ->
        assert "Slot number #{slot} is free now" == SmartParking.leave(slot)
      end)
    end

    test "invalid leave parking" do
      # setup
      invalid_slot = 99

      assert "Invalid slot id or slot already empty" == SmartParking.leave(invalid_slot)
    end

    test "invalid slot id error while delete parking slot" do
      # setup
      invalid_slot = 999

      assert "Invalid slot number" == SmartParking.delete_slot(invalid_slot)
    end

    test "invalid slot id type error while delete parking slot" do
      # setup
      invalid_slot = "hello"

      assert "Invalid slot number type" == SmartParking.delete_slot(invalid_slot)
    end

    test "Can not delete used slot", %{slots: slots, vehicles: vehicles} do
      # Park vehicles
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        SmartParking.park(registration_no, color)
      end)

      Enum.each(slots, fn slot ->
        assert "Can not delete used slot" == SmartParking.delete_slot(slot)
      end)
    end

    test "delete parking slot", %{slots: slots} do
      Enum.each(slots, fn slot ->
        assert "Slot number #{slot} is no longer available" == SmartParking.delete_slot(slot)
      end)
    end

    # TODO: Needs to implement this application in such a way that we can search by color
    # and registration number and even can allow exit if parked with proper receipt
    test "color vehicle", %{color: color, vehicles: vehicles} do
      colored_vehicles =
        vehicles |> Enum.filter(&(&1.color == color)) |> Enum.map(& &1.registration_no)

      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        SmartParking.park(registration_no, color)
      end)

      found_colored_vechiles = SmartParking.registration_numbers_for_cars_with_colour(color)

      Enum.each(found_colored_vechiles, fn found ->
        assert found in colored_vehicles
      end)
    end

    test "registration vechile slot", %{
      vehicles: vehicles,
      registration_no: registration_no
    } do
      Enum.each(vehicles, fn %{registration_no: registration_no, color: color} ->
        SmartParking.park(registration_no, color)
      end)

      # we are taking the last slot so we can assume that it'll be on the last place
      assert 5 == SmartParking.slot_number_for_registration_number(registration_no)
    end

    test "invalid registration vechile slot", %{
      invalid_registration_no: registration_no
    } do
      assert "Not found" == SmartParking.slot_number_for_registration_number(registration_no)
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
    {:ok, Map.put(context, :parking_lot, SmartParking.create_parking_lot(5))}
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
