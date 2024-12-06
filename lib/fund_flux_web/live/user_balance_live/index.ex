defmodule FundFluxWeb.UserBalanceLive.Index do
  use FundFluxWeb, :live_view

  alias FundFlux.Accounts
  alias FundFlux.Accounts.UserBalance

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :user_balances, Accounts.list_user_balances())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User balance")
    |> assign(:user_balance, Accounts.get_user_balance!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User balance")
    |> assign(:user_balance, %UserBalance{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User balances")
    |> assign(:user_balance, nil)
  end

  @impl true
  def handle_info({FundFluxWeb.UserBalanceLive.FormComponent, {:saved, user_balance}}, socket) do
    {:noreply, stream_insert(socket, :user_balances, user_balance)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_balance = Accounts.get_user_balance!(id)
    {:ok, _} = Accounts.delete_user_balance(user_balance)

    {:noreply, stream_delete(socket, :user_balances, user_balance)}
  end
end
