defmodule Cup.Repo do
  use Ecto.Repo,
    otp_app: :cup,
    adapter: Ecto.Adapters.Postgres
end
