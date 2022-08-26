defmodule LiveViewStudioWeb.SalesDashboardLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "refreshes when refresh button is clicked", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sales-dashboard")

    before_refresh = render(view)

    after_refresh =
      view
      |> element("button", "Refresh")
      |> render_click()

    refute after_refresh =~ before_refresh
  end

  test "refreshes automatically every tick", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sales-dashboard")

    before_refresh = render(view)

    send(view.pid, :tick)

    refute render(view) =~ before_refresh
  end

  test "refreshes the sales amount every tick", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sales-dashboard")

    before_refresh_sales_amount =
      view
      |> render()
      |> get_text_for_selector("#sales-amount")

    send(view.pid, :tick)

    after_refresh_sales_amount =
      view
      |> render()
      |> get_text_for_selector("#sales-amount")

    refute before_refresh_sales_amount =~ after_refresh_sales_amount
  end

  # Use Flocki
  defp get_text_for_selector(html, selector) do
    html
    |> Floki.parse_document!()
    |> Floki.find(selector)
    |> Floki.text()
  end
end
