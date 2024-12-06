defmodule FundFluxWeb.UserBalanceLiveTest do
  use FundFluxWeb.ConnCase

  import Phoenix.LiveViewTest
  import FundFlux.AccountsFixtures

  @create_attrs %{balance: "120.5"}
  @update_attrs %{balance: "456.7"}
  @invalid_attrs %{balance: nil}

  defp create_user_balance(_) do
    user_balance = user_balance_fixture()
    %{user_balance: user_balance}
  end

  describe "Index" do
    setup [:create_user_balance]

    test "lists all user_balances", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/user_balances")

      assert html =~ "Listing User balances"
    end

    test "saves new user_balance", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_balances")

      assert index_live |> element("a", "New User balance") |> render_click() =~
               "New User balance"

      assert_patch(index_live, ~p"/user_balances/new")

      assert index_live
             |> form("#user_balance-form", user_balance: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_balance-form", user_balance: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_balances")

      html = render(index_live)
      assert html =~ "User balance created successfully"
    end

    test "updates user_balance in listing", %{conn: conn, user_balance: user_balance} do
      {:ok, index_live, _html} = live(conn, ~p"/user_balances")

      assert index_live |> element("#user_balances-#{user_balance.id} a", "Edit") |> render_click() =~
               "Edit User balance"

      assert_patch(index_live, ~p"/user_balances/#{user_balance}/edit")

      assert index_live
             |> form("#user_balance-form", user_balance: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_balance-form", user_balance: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_balances")

      html = render(index_live)
      assert html =~ "User balance updated successfully"
    end

    test "deletes user_balance in listing", %{conn: conn, user_balance: user_balance} do
      {:ok, index_live, _html} = live(conn, ~p"/user_balances")

      assert index_live |> element("#user_balances-#{user_balance.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_balances-#{user_balance.id}")
    end
  end

  describe "Show" do
    setup [:create_user_balance]

    test "displays user_balance", %{conn: conn, user_balance: user_balance} do
      {:ok, _show_live, html} = live(conn, ~p"/user_balances/#{user_balance}")

      assert html =~ "Show User balance"
    end

    test "updates user_balance within modal", %{conn: conn, user_balance: user_balance} do
      {:ok, show_live, _html} = live(conn, ~p"/user_balances/#{user_balance}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User balance"

      assert_patch(show_live, ~p"/user_balances/#{user_balance}/show/edit")

      assert show_live
             |> form("#user_balance-form", user_balance: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_balance-form", user_balance: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_balances/#{user_balance}")

      html = render(show_live)
      assert html =~ "User balance updated successfully"
    end
  end
end
