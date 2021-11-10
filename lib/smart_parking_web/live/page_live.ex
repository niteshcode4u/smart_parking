defmodule SmartParkingWeb.PageLive do
  use SmartParkingWeb, :live_view
  alias SmartParking.Fence.ParkingManager
  alias SmartParking.Fence.TicketManager

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: SmartParkingWeb.Endpoint.subscribe(@topic)

    {:ok, fetch_assigns(socket)}
  end

  @impl true
  @spec handle_event(<<_::32, _::_*8>>, any, any) :: {:noreply, any}
  def handle_event("status", _data, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("create", %{"create" => number}, socket) do
    number
    |> String.to_integer()
    |> ParkingManager.create_slots()

    socket = fetch_assigns(socket)
    SmartParkingWeb.Endpoint.broadcast_from(self(), @topic, "create", socket.assigns)
    {:noreply, socket}
  end

  def handle_event("park", %{"reg_no" => reg_no, "vehicle_color" => color}, socket) do
    case ParkingManager.park(reg_no, color) do
      {:ok, _data} ->
        socket = fetch_assigns(socket)
        SmartParkingWeb.Endpoint.broadcast_from(self(), @topic, "park", socket.assigns)
        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("leave", %{"id" => id, "value" => _}, socket) do
    id
    |> String.to_integer()
    |> ParkingManager.leave()
    |> case do
      :success ->
        socket = fetch_assigns(socket)
        SmartParkingWeb.Endpoint.broadcast_from(self(), @topic, "leave", socket.assigns)
        {:noreply, socket}

      _ ->
        # TODO: Needs to handle error case properly
        {:noreply, socket}
    end
  end

  defp fetch_assigns(socket) do
    assign(
       socket,
       status: ParkingManager.state(),
       tickets: TicketManager.get_all_tickets()
     )
  end

  def get_datetime(time) do
    time
    |> to_string
    |> String.split(".")
    |> hd
  end
end
