defmodule FundFlux.Repo.Migrations.CreateMoneyTransfers do
  use Ecto.Migration

  def change do
    create table(:money_transfers) do
      add :amount, :decimal
      add :from_user_id, references(:users, on_delete: :nothing)
      add :to_user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
