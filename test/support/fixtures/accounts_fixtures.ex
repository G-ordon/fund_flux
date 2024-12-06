defmodule FundFlux.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FundFlux.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> FundFlux.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a money_transfer.
  """
  def money_transfer_fixture(attrs \\ %{}) do
    {:ok, money_transfer} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        status: "some status"
      })
      |> FundFlux.Accounts.create_money_transfer()

    money_transfer
  end



  @doc """
  Generate a user_balance.
  """
  def user_balance_fixture(attrs \\ %{}) do
    {:ok, user_balance} =
      attrs
      |> Enum.into(%{
        balance: "120.5"
      })
      |> FundFlux.Accounts.create_user_balance()

    user_balance
  end
end
