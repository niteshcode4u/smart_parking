defmodule SmartParking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # disabed currently as we are not using database.
      # SmartParking.Repo,
      SmartParkingWeb.Telemetry,
      {Phoenix.PubSub, name: SmartParking.PubSub},
      SmartParkingWeb.Endpoint,
      {SmartParking.Fence.TicketManager, []},
      {SmartParking.Fence.ParkingManager, 10}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmartParking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartParkingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
