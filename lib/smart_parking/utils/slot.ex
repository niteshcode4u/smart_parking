defmodule ParkingLot.Utils.Slot do
  @moduledoc """
  This module is to provide slot information
  """

  @enforce_keys ~w(id)a
  defstruct ~w(id ticket_id type)a

  @spec new(Keyword.t() | map()) :: %{:__struct__ => atom, optional(atom) => any}
  def new(fields), do: struct!(__MODULE__, fields)
end
