defmodule LiveViewStudioWeb.HeaderComponent do
  use LiveViewStudioWeb, :live_component

  def render(assigns) do
    ~H"""
    <h1 class="mb-2">
      <%= @title %>
    </h1>
    <h2 class="text-center text-2xl text-gray-500 mb-8 py-10">
      <%= @subtitle %>
    </h2>
    """
  end
end
