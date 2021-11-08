defmodule SmartParking.Fence.TicketManager do
  @moduledoc """
  This module helps on managing ticket session state
  """
  use GenServer
  alias ParkingLot.Utils.Ticket

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(tickets) when is_list(tickets), do: {:ok, tickets}

  def init(_tickets), do: {:error, "Tickets must be list"}

  ###############################################################################
  #######################           Public APIs           #######################
  ###############################################################################

  def add_ticket(manager \\ __MODULE__, %Ticket{} = ticket),
    do: GenServer.call(manager, {:add, ticket})

  def get_ticket(manager \\ __MODULE__, ticket_id), do: GenServer.call(manager, {:get, ticket_id})
  def get_all_tickets(manager \\ __MODULE__), do: GenServer.call(manager, {:get_all})

  def update_ticket_on_exit(manager \\ __MODULE__, ticket_id),
    do: GenServer.call(manager, {:update_time, ticket_id})

  def clear_all_tickets(manager \\ __MODULE__), do: GenServer.cast(manager, :delete_all)

  ###############################################################################
  #######################           Call handlers           #####################
  ###############################################################################

  @impl true
  def handle_call({:add, ticket}, _from, tickets), do: {:reply, ticket, [ticket | tickets]}

  @impl true
  def handle_call({:get, ticket_id}, _from, tickets),
    do: {:reply, fetch_ticket(tickets, ticket_id), tickets}

  @impl true
  def handle_call({:get_all}, _from, tickets), do: {:reply, tickets, tickets}

  @impl true
  def handle_call({:update_time, ticket_id}, _from, tickets) do
    tickets =
      tickets
      |> Enum.map(fn ticket ->
        case ticket.id == ticket_id do
          true ->
            %{ticket | exit_time: DateTime.utc_now()}

          false ->
            ticket
        end
      end)

    {:reply, :ok, tickets}
  end

  @impl true
  def handle_cast(:delete_all, _tickets), do: {:noreply, []}

  ###############################################################################
  #######################            Private fun            #####################
  ###############################################################################

  defp fetch_ticket(tickets, ticket_id),
    do: Enum.filter(tickets, fn ticket -> ticket.id == ticket_id end)
end
