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
    page = param_to_integer(params["page"], 1)
    per_page = param_to_integer(params["per_page"], 5)

    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    vehicles =
      Vehicles.list_vehicles(
        paginate: paginate_options,
        sort: sort_options
      )

    socket =
      assign(socket,
        options:  Map.merge(paginate_options, sort_options),
        vehicles: vehicles
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = param_to_integer(per_page, 5)

    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: socket.assigns.options.page,
            per_page: per_page,
            sort_by: socket.assigns.options.sort_by,
            sort_order: socket.assigns.options.sort_order
          )
      )

    {:noreply, socket}
  end

  def handle_event("paginate", %{"key" => "ArrowRight"}, socket) do
    {:noreply, goto_page(socket, socket.assigns.options.page + 1)}
  end

  def handle_event("paginate", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, goto_page(socket, socket.assigns.options.page - 1)}
  end

  def handle_event("paginate", %{"key" => key}, socket) do
    IO.inspect(key)
    {:noreply, socket}
  end

  defp pagination_link(socket, text, page, options, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
        ),
      class: class
    )
  end

  defp sort_link(socket, text, sort_by, options) do
    text =
      case options do
        %{sort_by: ^sort_by, sort_order: _sort_order} ->
          text <> emoji(options.sort_order)
        _ ->
          text
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order),
          page: options.page,
          per_page: options.per_page
        )
    )
  end

  defp goto_page(socket, page) when page > 0 do
    push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: page,
            per_page: socket.assigns.options.per_page,
            sort_by: socket.assigns.options.sort_by,
            sort_order: socket.assigns.options.sort_order
          )
      )
  end

  defp goto_page(socket, _page), do: socket


  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp emoji(:asc), do: "👇"
  defp emoji(:desc), do: "👆"

  defp param_to_integer(nil, default_value), do: default_value
  defp param_to_integer(param, default_value) do
    case Integer.parse(param) do
      {number, _} ->
        number

      :error ->
        default_value
    end
  end
end
