defmodule TravelConstellation.Repo do
  use Ecto.Repo,
    otp_app: :travel_constellation,
    adapter: Ecto.Adapters.Postgres
end
