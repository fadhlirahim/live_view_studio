defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Volunteers

  def mount(_params, _session, socket) do
    if connected?(socket), do: Volunteers.subscribe()

    volunteers = Volunteers.list_volunteers()

    socket =
      assign(socket,
        volunteers: volunteers,
        recent_activity: nil
      )

    {:ok, socket, temporary_assigns: [volunteers: []]}
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket =
      update(
        socket,
        :volunteers,
        fn volunteers -> [volunteer | volunteers] end
      )

    socket = recent_activity(socket, volunteer)

    {:noreply, socket}
  end

  def handle_info({:volunteer_updated, volunteer}, socket) do
    socket =
      update(
        socket,
        :volunteers,
        fn volunteers -> [volunteer | volunteers] end
      )

    socket = recent_activity(socket, volunteer)

    {:noreply, socket}
  end

  defp recent_activity(socket, volunteer) do
    assign(socket,
      recent_activity: "#{volunteer.name} checked
        #{if volunteer.checked_out, do: "out", else: "in"}!"
    )
  end
end
