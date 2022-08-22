defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.QuoteComponent
  alias LiveViewStudioWeb.SandboxCalculatorComponent
  alias LiveViewStudioWeb.DeliveryChargeComponent

  def mount(_params, _session, socket) do
    {:ok, assign(socket, weight: nil, price: nil, zip: nil, delivery_charge: 0)}
  end

  def render(assigns) do
    ~L"""
    <h1>Build A Sandbox</h1>

    <div id="sandbox">
      <%= live_component @socket, SandboxCalculatorComponent,
                         id: 1,
                         coupon: 10.0 %>

      <%= live_component @socket, DeliveryChargeComponent,
                         id: 1, zip: @zip %>

      <%= if @weight do %>
        <%= live_component @socket, QuoteComponent,
                          material: "sand",
                          weight: @weight,
                          price: @price,
                          delivery_charge: @delivery_charge %>
      <% end %>
    </div>
    """
  end

  def handle_info({:totals, weight, price}, socket) do
    socket = assign(socket, weight: weight, price: price)
    {:noreply, socket}
  end

  # New function to handle the message sent from
  # the DeliveryChargeComponent.
  def handle_info({DeliveryChargeComponent, :delivery_charge, charge}, socket) do
    socket = assign(socket, delivery_charge: charge)
    {:noreply, socket}
  end
end
