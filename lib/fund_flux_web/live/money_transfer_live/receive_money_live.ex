defmodule FundFluxWeb.MoneyTransferLive.ReceiveMoney do
  use FundFluxWeb, :live_view

  alias FundFlux.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, amount: nil)}
  end

  @impl true
  def handle_event("receive_money", %{"amount" => amount}, socket) do
    amount = String.to_integer(amount)

    # Call the function to receive money
    case Accounts.receive_money(socket.assigns.current_user.id, amount) do
      {:ok, _money_transfer} ->
        {:noreply, put_flash(socket, :info, "Money received successfully.")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to receive money.")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <style>
      .container {
        max-width: 600px;
        margin: 20px auto;

      }

      .card {
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }

      .form-control {
        width: 100%;
      }

      .text-center {
        text-align: center;

      }
    </style>

    <div class="container">
      <h1 class="text-center">Receive Money</h1>

      <%= if @flash[:info] do %>
        <div class="alert alert-info"><%= @flash[:info] %></div>
      <% end %>

      <%= if @flash[:error] do %>
        <div class="alert alert-danger"><%= @flash[:error] %></div>
      <% end %>

      <div class="card">
        <div class="card-body">
          <form phx-submit="receive_money" class="form-inline">
            <div class="form-group mb-2">
              <label for="amount" class="sr-only">Amount:</label>
              <input type="number" name="amount" required class="form-control" placeholder="Enter amount" />
            </div>
            <button type="submit" class="btn btn-primary mb-2 ml-2">Receive</button>
          </form>
        </div>
      </div>
    </div>
    """
  end
end
