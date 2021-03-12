defmodule Pokestats.Repo do
  use Ecto.Repo,
    otp_app: :pokestats,
    adapter: Ecto.Adapters.Postgres
end
