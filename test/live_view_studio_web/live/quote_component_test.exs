defmodule LiveViewStudioWeb.QuoteComponentTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudioWeb.QuoteComponent

  test "renders a quote" do
    assigns = [
      material: "sand",
      weight: 2.0,
      price: 4.0,
      hrs_until_expires: "24"
    ]

    html = render_component(&QuoteComponent.quote/1, assigns)

    assert html =~ "2.0 pounds of sand"
    assert html =~ "expires in 24 hours"
  end
end
