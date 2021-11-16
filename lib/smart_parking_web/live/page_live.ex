defmodule SmartParkingWeb.PageLive do
  use SmartParkingWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket), do: SmartParkingWeb.Endpoint.subscribe("live")

    {:ok, update_assigns(socket)}
  end

  @impl Phoenix.LiveView
  def handle_event("status", _data, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("create", %{"create" => number}, socket) do
    number
    |> String.to_integer()
    |> SmartParking.create_parking_lot()

    socket = update_assigns(socket)
    SmartParking.broadcast_status(self(), "create", socket.assigns)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("extend", %{"extend" => number}, socket) do
    number
    |> String.to_integer()
    |> SmartParking.extend_slots()

    socket = update_assigns(socket)
    SmartParking.broadcast_status(self(), "extend", socket.assigns)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("delete_slot", %{"slot_id" => slot_id}, socket) do
    slot_id
    |> String.to_integer()
    |> SmartParking.delete_slot()

    socket = update_assigns(socket)
    SmartParking.broadcast_status(self(), "delete", socket.assigns)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("park", %{"reg_no" => reg_no, "vehicle_color" => color}, socket) do
    SmartParking.park(reg_no, color)
    socket = update_assigns(socket)
    SmartParking.broadcast_status(self(), "park", socket.assigns)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("leave", %{"id" => id, "value" => _}, socket) do
    id
    |> String.to_integer()
    |> SmartParking.leave()

    socket = update_assigns(socket)
    SmartParking.broadcast_status(self(), "leave", socket.assigns)
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(_data, socket) do
    {:noreply, update_assigns(socket)}
  end

  defp update_assigns(socket),
    do: assign(socket, status: SmartParking.status())

  def get_datetime(time) do
    time
    |> to_string
    |> String.split(".")
    |> hd
  end
end
