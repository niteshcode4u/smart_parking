defmodule SmartParking.Repo do
  use Ecto.Repo,
    otp_app: :smart_parking,
    adapter: Ecto.Adapters.Postgres
end
