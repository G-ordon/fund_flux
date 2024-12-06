defmodule FundFluxWeb.UserBalanceLive.FormComponent do
  use FundFluxWeb, :live_component

  alias FundFlux.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user_balance records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_balance-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:balance]} type="number" label="Balance" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save User balance</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_balance: user_balance} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_user_balance(user_balance))
     end)}
  end

  @impl true
  def handle_event("validate", %{"user_balance" => user_balance_params}, socket) do
    changeset = Accounts.change_user_balance(socket.assigns.user_balance, user_balance_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"user_balance" => user_balance_params}, socket) do
    save_user_balance(socket, socket.assigns.action, user_balance_params)
  end

  defp save_user_balance(socket, :edit, user_balance_params) do
    case Accounts.update_user_balance(socket.assigns.user_balance, user_balance_params) do
      {:ok, user_balance} ->
        notify_parent({:saved, user_balance})

        {:noreply,
         socket
         |> put_flash(:info, "User balance updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_user_balance(socket, :new, user_balance_params) do
    case Accounts.create_user_balance(user_balance_params) do
      {:ok, user_balance} ->
        notify_parent({:saved, user_balance})

        {:noreply,
         socket
         |> put_flash(:info, "User balance created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
