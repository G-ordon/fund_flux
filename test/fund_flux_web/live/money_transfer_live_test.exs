defmodule FundFluxWeb.MoneyTransferLiveTest do
  use FundFluxWeb.ConnCase

  import Phoenix.LiveViewTest
  import FundFlux.AccountsFixtures

  @create_attrs %{amount: "120.5"}
  @update_attrs %{amount: "456.7"}
  @invalid_attrs %{amount: nil}

  defp create_money_transfer(_) do
    money_transfer = money_transfer_fixture()
    %{money_transfer: money_transfer}
  end

  describe "Index" do
    setup [:create_money_transfer]

    test "lists all money_transfers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/money_transfers")

      assert html =~ "Listing Money transfers"
    end

    test "saves new money_transfer", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/money_transfers")

      assert index_live |> element("a", "New Money transfer") |> render_click() =~
               "New Money transfer"

      assert_patch(index_live, ~p"/money_transfers/new")

      assert index_live
             |> form("#money_transfer-form", money_transfer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#money_transfer-form", money_transfer: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/money_transfers")

      html = render(index_live)
      assert html =~ "Money transfer created successfully"
    end

    test "updates money_transfer in listing", %{conn: conn, money_transfer: money_transfer} do
      {:ok, index_live, _html} = live(conn, ~p"/money_transfers")

      assert index_live |> element("#money_transfers-#{money_transfer.id} a", "Edit") |> render_click() =~
               "Edit Money transfer"

      assert_patch(index_live, ~p"/money_transfers/#{money_transfer}/edit")

      assert index_live
             |> form("#money_transfer-form", money_transfer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#money_transfer-form", money_transfer: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/money_transfers")

      html = render(index_live)
      assert html =~ "Money transfer updated successfully"
    end

    test "deletes money_transfer in listing", %{conn: conn, money_transfer: money_transfer} do
      {:ok, index_live, _html} = live(conn, ~p"/money_transfers")

      assert index_live |> element("#money_transfers-#{money_transfer.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#money_transfers-#{money_transfer.id}")
    end
  end

  describe "Show" do
    setup [:create_money_transfer]

    test "displays money_transfer", %{conn: conn, money_transfer: money_transfer} do
      {:ok, _show_live, html} = live(conn, ~p"/money_transfers/#{money_transfer}")

      assert html =~ "Show Money transfer"
    end

    test "updates money_transfer within modal", %{conn: conn, money_transfer: money_transfer} do
      {:ok, show_live, _html} = live(conn, ~p"/money_transfers/#{money_transfer}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Money transfer"

      assert_patch(show_live, ~p"/money_transfers/#{money_transfer}/show/edit")

      assert show_live
             |> form("#money_transfer-form", money_transfer: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#money_transfer-form", money_transfer: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/money_transfers/#{money_transfer}")

      html = render(show_live)
      assert html =~ "Money transfer updated successfully"
    end
  end
end
