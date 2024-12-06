defmodule FundFluxWeb.MoneyTransferLive.Show do
  use FundFluxWeb, :live_view

  alias FundFlux.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:money_transfer, Accounts.get_money_transfer!(id))}
  end

  defp page_title(:show), do: "Show Money transfer"
  defp page_title(:edit), do: "Edit Money transfer"
end
