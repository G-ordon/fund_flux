defmodule FundFlux.Accounts.UserBalance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_balances" do
    field :balance, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_balance, attrs) do
    user_balance
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end
