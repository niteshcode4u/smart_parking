defmodule SmartParking do
  @moduledoc """
  SmartParking keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias SmartParking.Fence.{ParkingManager, TicketManager}
  alias SmartParking.Utils.ParkingLot

  def create_parking_lot(slot_count) do
    case is_integer(slot_count) do
      true ->
        TicketManager.clear_all_tickets()
        ParkingManager.create_slots(slot_count)

      false ->
        "Invalid slot count type"
    end
  end

  def extend_slots(slot_count) do
    case is_integer(slot_count) do
      true -> ParkingManager.extend_slots(slot_count)
      false -> "Invalid slot count type"
    end
  end

  def delete_slot(slot_no) do
    with true <- is_integer(slot_no),
         :not_occupied <- is_slot_no_occupied(slot_no),
         :success <- ParkingManager.delete_slot(slot_no) do
      "Slot number #{slot_no} is no longer available"
    else
      false -> "Invalid slot number type"
      :occupied -> "Can not delete used slot"
      _ -> "Invalid slot number"
    end
  end

  @spec park(String.t(), String.t()) :: pos_integer() | String.t()
  def park(registration_no, color) do
    case ParkingManager.park(registration_no, color) do
      {:ok, _ticket} -> :success
      {:error, msg} -> msg
    end
  end

  @spec leave(pos_integer()) :: String.t()
  def leave(slot_no) do
    case ParkingManager.leave(slot_no) do
      :success ->
        "Slot number #{slot_no} is free now"

      _ ->
        "Invalid slot id or slot already empty"
    end
  end

  @spec status :: [map()]
  def status() do
    active_tickets = get_active_tickets()

    occupied_slots =
      TicketManager.get_all_tickets()
      |> Enum.filter(&(&1.id in active_tickets))
      |> Enum.map(
        &%{
          id: &1.slot_id,
          registration_no: &1.vehicle.registration_no,
          color: &1.vehicle.color,
          entry_time: &1.entry_time
        }
      )

    all_slots = occupied_slots ++ ParkingManager.state().slots

    Enum.sort_by(all_slots, & &1.id)
  end

  def active_status() do
    active_tickets = get_active_tickets()

    TicketManager.get_all_tickets()
    |> Enum.filter(&(&1.id in active_tickets))
    |> Enum.map(
      &%{
        slot_no: &1.slot_id,
        registration_no: &1.vehicle.registration_no,
        color: &1.vehicle.color
      }
    )
  end

  @spec registration_numbers_for_cars_with_colour(String.t()) :: [String.t()]
  def registration_numbers_for_cars_with_colour(color) do
    active_status() |> Enum.filter(&(&1.color == color)) |> Enum.map(& &1.registration_no)
  end

  @spec slot_numbers_for_cars_with_colour(String.t()) :: [number()]
  def slot_numbers_for_cars_with_colour(color) do
    active_status() |> Enum.filter(&(&1.color == color)) |> Enum.map(& &1.slot_no)
  end

  @spec slot_number_for_registration_number(String.t()) :: [number()]
  def slot_number_for_registration_number(registration_no) do
    resp =
      active_status()
      |> Enum.filter(&(&1.registration_no == registration_no))
      |> Enum.map(& &1.slot_no)
      |> List.first()

    if resp == nil, do: "Not found", else: resp
  end

  def broadcast_status(pid, event, message),
    do: SmartParkingWeb.Endpoint.broadcast_from(pid, "live", event, message)

  defp get_active_tickets() do
    %ParkingLot{used_slots: used_slots} = ParkingManager.state()
    used_slots |> Enum.map(& &1.ticket_id)
  end

  defp is_slot_no_occupied(slot_no) do
    ParkingManager.state().used_slots
    |> Enum.find(&(&1.id == slot_no))
    |> case do
      nil -> :not_occupied
      _data -> :occupied
    end
  end
end
