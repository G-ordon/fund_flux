defmodule FundFlux.Repo.Migrations.CreateUserBalances do
  use Ecto.Migration

  def change do
    create table(:user_balances) do
      add :balance, :decimal, default: 0.0

      timestamps(type: :utc_datetime)
    end
  end
end
