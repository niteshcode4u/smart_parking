defmodule ParkingLot.Utils.Vehicle do
  @moduledoc """
  This module provides the basic details of a vehicle.
  """

  @enforce_keys ~w(color registration_no)a
  defstruct ~w(color registration_no)a

  @spec new(map() | Keyword.t()) :: %{:__struct__ => atom()}
  def new(fields), do: struct!(__MODULE__, fields)
end
