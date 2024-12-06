defmodule FundFluxWeb.MoneyTransferLive.FormComponent do
  use FundFluxWeb, :live_component

  alias FundFlux.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage money_transfer records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="money_transfer-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Money transfer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{money_transfer: money_transfer} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_money_transfer(money_transfer))
     end)}
  end

  @impl true
  def handle_event("validate", %{"money_transfer" => money_transfer_params}, socket) do
    changeset = Accounts.change_money_transfer(socket.assigns.money_transfer, money_transfer_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"money_transfer" => money_transfer_params}, socket) do
    save_money_transfer(socket, socket.assigns.action, money_transfer_params)
  end

  defp save_money_transfer(socket, :edit, money_transfer_params) do
    case Accounts.update_money_transfer(socket.assigns.money_transfer, money_transfer_params) do
      {:ok, money_transfer} ->
        notify_parent({:saved, money_transfer})

        {:noreply,
         socket
         |> put_flash(:info, "Money transfer updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_money_transfer(socket, :new, money_transfer_params) do
    case Accounts.create_money_transfer(money_transfer_params) do
      {:ok, money_transfer} ->
        notify_parent({:saved, money_transfer})

        {:noreply,
         socket
         |> put_flash(:info, "Money transfer created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
