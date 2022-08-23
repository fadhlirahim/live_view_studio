defmodule LiveViewStudioWeb.LoadingComponent do
  use LiveViewStudioWeb, :live_component

  def render(assigns) do
    ~H"""
    <%= if @loading do %>
      <div class="loader">
        Loading...
      </div>
    <% end %>
    """
  end
end
