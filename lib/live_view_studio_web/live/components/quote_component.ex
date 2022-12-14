defmodule LiveViewStudioWeb.QuoteComponent do
  use LiveViewStudioWeb, :live_component

  import Number.Currency

  def mount(socket) do
    {:ok, assign(socket,
            hrs_until_expires: 24,
            delivery_charge: nil)}
  end

  def render(assigns) do
    ~L"""
    <div id="quote" class="text-center p-6 border-4 border-dashed border-indigo-600">
      <h2 class="text-2xl mb-2">
        Our Best Deal:
      </h2>
      <h3 class="text-xl font-semibold text-indigo-600">
        <%= @weight %> pounds of <%= @material %>
        for <%= number_to_currency(@price) %>
      </h3>

      <h4 class="text-xl font-semibold text-indigo-600">
        plus <%= number_to_currency(@delivery_charge) %> delivery
      </h4>

      <div class="text-gray-600">
        expires in <%= @hrs_until_expires %> hours
      </div>
    </div>
    """
  end
end
