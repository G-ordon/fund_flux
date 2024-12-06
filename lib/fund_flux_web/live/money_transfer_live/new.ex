defmodule FundFluxWeb.MoneyTransferLive.New do
  use FundFluxWeb, :live_view

  alias FundFlux.Accounts
  alias FundFlux.Accounts.MoneyTransfer


  def mount(_params, _session, socket) do
    # Fetch the users and their balances for the form
    balances = Accounts.list_user_balances()  # Get the user balances from your context
    changeset = Accounts.change_money_transfer(%MoneyTransfer{})  # Create an empty changeset for the MoneyTransfer

    # Assign the balances and changeset to the socket
    {:ok, assign(socket, changeset: changeset, balances: balances, transfer_result: nil)}
  end



  def handle_event("transfer_money", %{"money_transfer" => %{"from_user_email" => from_email, "to_user_email" => to_email, "amount" => amount}}, socket) do
  IO.inspect(amount, label: "Amount before conversion")  # Debugging output

  # Convert amount to Decimal and handle any potential errors
  case Float.parse(String.trim(amount)) do
    {amount_float, ""} ->  # Successfully parsed amount
      # Convert float to string and then to Decimal
      amount_decimal = Decimal.new(Float.to_string(amount_float))

      # Create a money transfer record or update user balances
      case Accounts.create_money_transfer(%{
             from_user_email: from_email,
             to_user_email: to_email,
             amount: amount_decimal
           }) do
        {:ok, _transfer} ->
          # Set flash message and redirect to money transfers page
          {:noreply,
           socket
           |> put_flash(:info, "Transfer successful!")
           |> push_navigate(to: "/money_transfers")}  # Change the route as needed

        {:error, :insufficient_balance_or_invalid_user} ->
          {:noreply, assign(socket, transfer_result: "Transfer failed: insufficient balance or invalid user.")}

        {:error, changeset} ->
          error_message = changeset.errors |> Keyword.get(:base) |> List.first() |> elem(0)
          {:noreply, assign(socket, transfer_result: "Transfer failed: #{error_message}")}

        _ ->
          {:noreply, assign(socket, transfer_result: "Transfer failed: unknown error.")}
      end

    _ ->  # Handle parsing error
      {:noreply, assign(socket, transfer_result: "Transfer failed: invalid amount.")}
  end
end


end
