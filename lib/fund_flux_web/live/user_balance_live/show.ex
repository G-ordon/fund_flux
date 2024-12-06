defmodule FundFluxWeb.UserBalanceLive.Show do
  use FundFluxWeb, :live_view

  alias FundFlux.Accounts

  @impl true

  def mount(_params, session, socket) do
    user = Accounts.get_user!(session["user_id"])  # Assuming you have user_id in the session
    {:ok, assign(socket, user: user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_balance, Accounts.get_user_balance!(id))}
  end

  defp page_title(:show), do: "Show User balance"
  defp page_title(:edit), do: "Edit User balance"
end
