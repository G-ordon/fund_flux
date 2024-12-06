defmodule FundFlux.Repo.Migrations.AddStatusToMoneyTransfers do
  use Ecto.Migration

  def change do
    alter table(:money_transfers) do
      add :status, :string
    end
  end

end
