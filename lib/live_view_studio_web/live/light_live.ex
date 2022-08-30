defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light" phx-window-keyup="update">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg">
        <span class="sr-only">Off</span>
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
        <span class="sr-only">Down</span>
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
        <span class="sr-only">Up</span>
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg">
        <span class="sr-only">On</span>
      </button>
    </div>
    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = increase_brightness(socket)
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = decrease_brightness(socket)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("update", %{"key" => "ArrowUp"}, socket) do
    socket = increase_brightness(socket)
    {:noreply, socket}
  end

  def handle_event("update", %{"key" => "ArrowDown"}, socket) do
    socket = decrease_brightness(socket)
    {:noreply, socket}
  end

  def handle_event("update", %{"key" => key}, socket) do
    IO.inspect(key)
    {:noreply, socket}
  end

  defp increase_brightness(socket) do
    update(socket, :brightness, &min(&1 + 10, 100))
  end

  defp decrease_brightness(socket) do
    update(socket, :brightness, &max(&1 - 10, 0))
  end
end
