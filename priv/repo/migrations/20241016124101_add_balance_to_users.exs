defmodule FundFlux.Repo.Migrations.AddBalanceToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :balance, :decimal, default: 0.0  # Add the balance field
    end
  end
end
