defmodule LiveViewStudioWeb.QuoteComponentTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudioWeb.QuoteComponent

  test "renders quote with 24-hour expiry by default" do
    assigns = [
      material: "sand",
      weight: 2.0,
      price: 4.0
    ]

    html = render_component(QuoteComponent, assigns)

    assert html =~ "2.0 pounds of sand"
    assert html =~ "expires in 24 hours"
  end

  test "renders an expiry when an expiry is provided" do
    assigns = [
      material: "sand",
      weight: 2.0,
      price: 4.0,
      hrs_until_expires: 12
    ]

    html = render_component(QuoteComponent, assigns)

    assert html =~ "expires in 12 hours"
  end

  test "renders a delivery charge when delivery_charge is provided" do
    assigns = [
      material: "sand",
      weight: 2.0,
      price: 4.0,
      hrs_until_expires: 12,
      delivery_charge: 10
    ]

    html = render_component(QuoteComponent, assigns)

    assert html =~ "plus $10.00 delivery"

  end
end
