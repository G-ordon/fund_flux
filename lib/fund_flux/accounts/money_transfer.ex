defmodule FundFlux.Accounts.MoneyTransfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "money_transfers" do
    field :amount, :decimal
    belongs_to :from_user, FundFlux.Accounts.User, foreign_key: :from_user_id
    belongs_to :to_user, FundFlux.Accounts.User, foreign_key: :to_user_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(money_transfer, attrs) do
    money_transfer
    |> cast(attrs, [:amount, :from_user_id, :to_user_id])
    |> validate_required([:amount, :from_user_id, :to_user_id])
  end
end
