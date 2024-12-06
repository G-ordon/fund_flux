defmodule FundFlux.Repo do
  use Ecto.Repo,
    otp_app: :fund_flux,
    adapter: Ecto.Adapters.Postgres
end
