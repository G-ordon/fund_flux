defmodule FundFluxWeb.MoneyTransferLive.Index do
  use FundFluxWeb, :live_view

  alias FundFlux.Accounts
  alias FundFlux.Accounts.MoneyTransfer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :money_transfers, Accounts.list_money_transfers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Money transfer")
    |> assign(:money_transfer, Accounts.get_money_transfer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Money transfer")
    |> assign(:money_transfer, %MoneyTransfer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Money transfers")
    |> assign(:money_transfer, nil)
  end

  @impl true
  def handle_info({FundFluxWeb.MoneyTransferLive.FormComponent, {:saved, money_transfer}}, socket) do
    {:noreply, stream_insert(socket, :money_transfers, money_transfer)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    money_transfer = Accounts.get_money_transfer!(id)
    {:ok, _} = Accounts.delete_money_transfer(money_transfer)

    {:noreply, stream_delete(socket, :money_transfers, money_transfer)}
  end
end
