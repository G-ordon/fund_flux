defmodule FundFlux.Repo.Migrations.AddEmailsToMoneyTransfers do
  use Ecto.Migration

  def change do
  alter table(:money_transfers) do
    add :from_user_email, :string
    add :to_user_email, :string
  end
  end
end
