defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(socket, total_vehicles: Vehicles.count_vehicles()),
      temporary_assigns: [vehicles: []]
    }
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    paginate_options = %{page: page, per_page: per_page}
    vehicles = Vehicles.list_vehicles(paginate: paginate_options)

    socket =
      assign(socket,
        options: paginate_options,
        vehicles: vehicles
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: socket.assigns.options.page,
            per_page: per_page
          )
      )

    {:noreply, socket}
  end

  defp pagination_link(socket, text, page, per_page, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: per_page
        ),
      class: class
    )
  end
end
